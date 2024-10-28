package dependency_inject

import dependency_inject.exceptions.*
import dependency_inject.resources.*
import std.collection.concurrent.*
import std.reflect.*

internal struct CallSiteValidatorState {
	private var _singleton: ?ServiceCallSite = None

	public mut prop singleton: ?ServiceCallSite {
		get() { _singleton }
		set(value) { _singleton = value }
	}
}

internal class CallSiteValidator <: CallSiteVisitor<CallSiteValidatorState, ?TypeInfo> {
	private let _scopedServices = ConcurrentHashMap<ServiceCacheKey, ?TypeInfo>()

	public func validateCallSite(callSite: ServiceCallSite): Unit {
		visitCallSite(callSite, CallSiteValidatorState())
	}

	public func validateResolution(callSite: ServiceCallSite, scope: IServiceScope, rootScope: IServiceScope) {
		if (refEq((scope as Object).getOrThrow(), (rootScope as Object).getOrThrow())) {

			let scopedServiceOption = _scopedServices.get(callSite.cache.key)
			if (scopedServiceOption.isSome()) {

				let scopedService = scopedServiceOption.getOrThrow()
				if (scopedService.isSome()) {

					let serviceType = callSite.serviceType
					if (serviceType == scopedServiceOption.getOrThrow().getOrThrow()) {
						throw InvalidOperationException(
							SR.format(SR.DirectScopedResolvedFromRootException, [
								callSite.serviceType.name,
								"scoped"
							])
						)
					}

					throw InvalidOperationException(
						SR.format(SR.ScopedResolvedFromRootException, [
							callSite.serviceType.name,
							scopedService,
							"scoped"
						])
					)
				}
			}
		}
	}

	protected override func visitCallSite(callSite: ServiceCallSite, argument: CallSiteValidatorState): ?TypeInfo {
		// First, check if we have encountered this call site before to prevent visiting call site trees that have already been visited
		// If firstScopedServiceInCallSiteTree is null there are no scoped dependencies in this service's call site tree
		// If firstScopedServiceInCallSiteTree has a value, it contains the first scoped service in this service's call site tree
		let firstScopedServiceInCallSiteTreeOption = _scopedServices.get(callSite.cache.key)
		var firstScopedServiceInCallSiteTree: ?TypeInfo = None
		if (firstScopedServiceInCallSiteTreeOption.isNone()) {
			// This call site wasn't cached yet, walk the tree
			firstScopedServiceInCallSiteTree = super.visitCallSite(callSite, argument)

			// Cache the result
			_scopedServices.put(callSite.cache.key, firstScopedServiceInCallSiteTree)
		}

		// If there is a scoped service in the call site tree, make sure we are not resolving it from a singleton
		if (firstScopedServiceInCallSiteTree.isSome() && argument.singleton.isSome()) {
			throw InvalidOperationException(SR.format(SR.ScopedInSingletonException, [
				callSite.serviceType.name,
				argument.singleton.getOrThrow().serviceType.name,
				"scoped",
				"singleton"
			]))
		}

		return firstScopedServiceInCallSiteTree
	}

	protected override func visitConstructor(constructorCallSite: ConstructorCallSite, state: CallSiteValidatorState): ?TypeInfo {
		var result: ?TypeInfo = None
		for (parameterCallSite in constructorCallSite.parameterCallSites) {
			let scoped = visitCallSite(parameterCallSite, state)
			if (result.isNone()) {
				result = scoped
			}
		}

		return result
	}

	protected override func visitIterable(iterableCallSite: IterableCallSite,
		state: CallSiteValidatorState): ?TypeInfo {
		var result: ?TypeInfo = None
		for (ServiceCallSite in iterableCallSite.serviceCallSites) {
			let scoped = visitCallSite(ServiceCallSite, state)
			if (result.isNone()) {
				result = scoped
			}
		}

		return result
	}

	protected override func visitRootCache(singletonCallSite: ServiceCallSite, state: CallSiteValidatorState): ?TypeInfo {
		var state2 = state
		state2.singleton = singletonCallSite
		return visitCallSiteMain(singletonCallSite, state2)
	}

	protected override func visitScopeCache(scopedCallSite: ServiceCallSite, state: CallSiteValidatorState): ?TypeInfo {
		// We are fine with having ServiceScopeService requested by singletons
		if (scopedCallSite.serviceType == TypeInfo.of<IServiceScopeFactory>()) {
			return None
		}

		visitCallSiteMain(scopedCallSite, state)
		return scopedCallSite.serviceType
	}

	protected override func visitConstant(_: ConstantCallSite, _: CallSiteValidatorState): ?TypeInfo { None }

	protected override func visitServiceProvider(_: ServiceProviderCallSite, _: CallSiteValidatorState): ?TypeInfo { None }

	protected override func visitFactory(_: FactoryCallSite, _: CallSiteValidatorState): ?TypeInfo { None }
}
