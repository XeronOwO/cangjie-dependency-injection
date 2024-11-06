package dependency_injection

import dependency_injection.corelib.*
import std.collection.*
import std.sync.*

internal class CallSiteRuntimeResolver <: CallSiteVisitor<RuntimeResolverContext, ?Any> {
	private static let _instance = CallSiteRuntimeResolver()

	public static prop instance: CallSiteRuntimeResolver {
		get() { _instance }
	}

	private init() {
	}

	public func resolve(callSite: ServiceCallSite, scope: ServiceProviderEngineScope): ?Object {
		// Fast path to avoid virtual calls if we already have the cached value in the root scope
		if (scope.isRootScope && callSite.value.isSome()) {
			return callSite.value.getOrThrow() as Object
		}

		var context = RuntimeResolverContext()
		context.scope = scope
		if (let Some(result) <- visitCallSite(callSite, context)) {
			return result as Object
		}
		return None
	}

	protected override func visitResourceCache(transientCallSite: ServiceCallSite, context: RuntimeResolverContext): ?Any {
		return context.scope.getOrThrow().captureResource(visitCallSiteMain(transientCallSite, context))
	}

	protected override func visitConstructor(constructorCallSite: ConstructorCallSite, context: RuntimeResolverContext): ?Any {
		let parameterValues: Array<Any>
		if (constructorCallSite.parameterCallSites.isEmpty()) {
			parameterValues = []
		} else {
			parameterValues = Array(constructorCallSite.parameterCallSites.size, { _ => None })
			for (index in 0..constructorCallSite.parameterCallSites.size) {
				parameterValues[index] = visitCallSite(constructorCallSite.parameterCallSites[index], context).getOrThrow()
			}
		}

		try {
			let instance = constructorCallSite.constructorInfo.apply(parameterValues)
			let objectInstance = (instance as Object).getOrThrow()
			return objectInstance
		} catch (ex: Exception) {
			throw ex
		}
	}

	protected override func visitRootCache(callSite: ServiceCallSite, context: RuntimeResolverContext): ?Any {
		if (callSite.value.isSome()) {
			// Value already calculated, return it directly
			return callSite.value.getOrThrow()
		}

		let lockType = RuntimeResolverLock.Root
		let serviceProviderEngine = context.scope.getOrThrow().rootProvider.root

		callSite.sync.lock()
		// Lock the callsite and check if another thread already cached the value
		if (callSite.value.isSome()) {
			return callSite.value.getOrThrow()
		}

		var context2 = RuntimeResolverContext()
		context2.scope = serviceProviderEngine
		context2.acquiredLocks = context.acquiredLocks | lockType
		let resolved = visitCallSiteMain(callSite, context2)
		serviceProviderEngine.captureResource(resolved)
		callSite.value = resolved
		callSite.sync.unlock()
		return resolved
	}

	protected override func visitScopeCache(callSite: ServiceCallSite, context: RuntimeResolverContext): ?Any {
		// Check if we are in the situation where scoped service was promoted to singleton
		// and we need to lock the root
		if (context.scope.getOrThrow().isRootScope) {
			return visitRootCache(callSite, context)
		} else {
			return visitCache(callSite, context, context.scope.getOrThrow(), RuntimeResolverLock.Scope)
		}
	}

	private func visitCache(callSite: ServiceCallSite, context: RuntimeResolverContext, serviceProviderEngine: ServiceProviderEngineScope, lockType: Int64): ?Any {
		var lockTaken = false
		let sync = serviceProviderEngine.sync
		let resolvedServices = serviceProviderEngine.resolvedServices
		// Taking locks only once allows us to fork resolution process
		// on another thread without causing the deadlock because we
		// always know that we are going to wait the other thread to finish before
		// releasing the lock
		if ((context.acquiredLocks & lockType) == 0) {
			lockTaken = sync.tryLock()
		}

		try {
			// Note: This method has already taken lock by the caller for resolution and access synchronization.
			// For scoped: takes a dictionary as both a resolution lock and a dictionary access lock.
			let resolvedOption = resolvedServices.get(callSite.cache.key)
			if (resolvedOption.isSome()) {
				return resolvedOption.getOrThrow()
			}

			var context2 = RuntimeResolverContext()
			context2.scope = serviceProviderEngine
			context2.acquiredLocks = context.acquiredLocks | lockType
			let resolved = visitCallSiteMain(callSite, context2)
			serviceProviderEngine.captureResource(resolved)
			resolvedServices.put(callSite.cache.key, resolved)
			return resolved
		} finally {
			if (lockTaken) {
				sync.unlock()
			}
		}
	}

	protected override func visitConstant(constantCallSite: ConstantCallSite, _: RuntimeResolverContext): ?Any {
		return constantCallSite.defaultValue
	}

	protected override func visitServiceProvider(_: ServiceProviderCallSite, context: RuntimeResolverContext): ?Any {
		return context.scope.getOrThrow()
	}

	protected override func visitIterable(_: IterableCallSite, _: RuntimeResolverContext): ?Any {
		throw NotImplementedException()
	}

	protected override func visitFactory(factoryCallSite: FactoryCallSite, context: RuntimeResolverContext): ?Any {
		return factoryCallSite.factory(context.scope.getOrThrow())
	}
}

internal struct RuntimeResolverContext {
	private var _scope: ?ServiceProviderEngineScope = None

	public mut prop scope: ?ServiceProviderEngineScope {
		get() { _scope }
		set(value) { _scope = value }
	}

	private var _acquiredLocks = 0

	public mut prop acquiredLocks: Int64 {
		get() { _acquiredLocks }
		set(value) { _acquiredLocks = value }
	}
}

/*
	enum 怎么不支持位运算？
	只能用 struct+Int64 先凑合了
*/
internal struct RuntimeResolverLock {
	public static let Scope = 1
	public static let Root = 2
}
