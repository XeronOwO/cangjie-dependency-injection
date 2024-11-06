package dependency_injection

import dependency_injection.abstractions.*
import dependency_injection.component_model.*
import dependency_injection.corelib.*
import std.collection.*
import std.collection.concurrent.*
import std.reflect.*

public class ServiceProvider <: IServiceProvider & IKeyedServiceProvider & Resource {
	private var _callSiteValidator: ?CallSiteValidator = None

	private var _createServiceAccessor: ?(ServiceIdentifier) -> ServiceAccessor = None

	// Internal for testing
	internal let _engine: ServiceProviderEngine

	private var _closed: Bool = false

	private let _serviceAccessors: ConcurrentHashMap<ServiceIdentifier, ServiceAccessor>

	private let _callSiteFactory: CallSiteFactory
	
	internal prop callSiteFactory: CallSiteFactory {
		get() { _callSiteFactory }
	}

	private var _root: ?ServiceProviderEngineScope = None

	internal prop root: ServiceProviderEngineScope {
		get() { _root.getOrThrow() }
	}

	internal init(serviceDescriptors: ICollection<ServiceDescriptor>, options: ServiceProviderOptions) {
		_engine = RuntimeServiceProviderEngine.instance
		_serviceAccessors = ConcurrentHashMap()

		_callSiteFactory = CallSiteFactory(serviceDescriptors)

		_createServiceAccessor = createServiceAccessor
		
		// note that Root needs to be set before calling GetEngine(), because the engine may need to access Root
		_root = ServiceProviderEngineScope(this, true)

		// The list of built in services that aren't part of the list of service descriptors
		// keep this in sync with CallSiteFactory.IsService
		_callSiteFactory.add(ServiceIdentifier.fromServiceType(TypeInfo.of<IServiceProvider>()), ServiceProviderCallSite())
		_callSiteFactory.add(ServiceIdentifier.fromServiceType(TypeInfo.of<IServiceScopeFactory>()), ConstantCallSite(TypeInfo.of<IServiceScopeFactory>(), root))
		_callSiteFactory.add(ServiceIdentifier.fromServiceType(TypeInfo.of<IServiceProviderIsService>()), ConstantCallSite(TypeInfo.of<IServiceProviderIsService>(), callSiteFactory))
		_callSiteFactory.add(ServiceIdentifier.fromServiceType(TypeInfo.of<IServiceProviderIsKeyedService>()), ConstantCallSite(TypeInfo.of<IServiceProviderIsKeyedService>(), callSiteFactory))

		if (options.validateScopes) {
			_callSiteValidator = CallSiteValidator()
		}

		if (options.validateOnBuild) {
			var exceptions: ?ArrayList<Exception> = None
			for (serviceDescriptor in serviceDescriptors) {
				try {
					validateService(serviceDescriptor)
				} catch (e: Exception) {
					if (exceptions.isNone()) {
						exceptions = ArrayList()
					}
					exceptions.getOrThrow().append(e)
				}
			}

			if (exceptions.isSome()) {
				throw AggregateException("Some services are not able to be constructed", exceptions.getOrThrow())
			}
		}
	}

	/*
	Gets the service object of the specified type.

	serviceType: The type of the service to get.

	returns: The service that was produced.
	*/
	public override func getService(serviceType: TypeInfo): ?Object {
		getService(ServiceIdentifier.fromServiceType(serviceType), root)
	}

	/*
	Gets the service object of the specified type with the specified key.

	serviceType: The type of the service to get.
	serviceKey: The key of the service to get.

	returns: The keyed service.
	*/
	public override func getKeyedService(serviceType: TypeInfo, serviceKey: ?IHashableEquatableToString<?Any>): ?Object {
		getKeyedService(serviceType, serviceKey, root)
	}

	internal func getKeyedService(serviceType: TypeInfo, serviceKey: ?IHashableEquatableToString<?Any>, serviceProviderEngineScope: ServiceProviderEngineScope): ?Object {
		getService(ServiceIdentifier(serviceKey, serviceType), serviceProviderEngineScope)
	}

	/*
	Gets the service object of the specified type.

	serviceType: The type of the service to get.
	serviceKey: The key of the service to get.

	returns: The keyed service.
	*/
	public override func getRequiredKeyedService(serviceType: TypeInfo, serviceKey: ?IHashableEquatableToString<?Any>): Object {
		getRequiredKeyedService(serviceType, serviceKey, root)
	}

	internal func getRequiredKeyedService(serviceType: TypeInfo, serviceKey: ?IHashableEquatableToString<?Any>, serviceProviderEngineScope: ServiceProviderEngineScope): Object {
		let service = getKeyedService(serviceType, serviceKey, serviceProviderEngineScope)
		if (service.isNone()) {
			throw InvalidOperationException(SR.format(SR.NoServiceRegistered, serviceType))
		}
		return service.getOrThrow()
	}

	public override func isClosed(): Bool {
		return _closed
	}

	public override func close(): Unit {
		closeCore()
		root.close()
	}

	private func closeCore() {
		_closed = true
	}

	private func onCreate(callSite: ServiceCallSite) {
		if (_callSiteValidator.isSome()) {
			_callSiteValidator.getOrThrow().validateCallSite(callSite)
		}
	}

	private func onResolve(callSite: ?ServiceCallSite, scope: IServiceScope) {
		if (callSite.isSome()) {
			if (_callSiteValidator.isSome()) {
				_callSiteValidator.getOrThrow().validateResolution(callSite.getOrThrow(), scope, root)
			}
		}
	}

	internal func getService(serviceIdentifier: ServiceIdentifier, serviceProviderEngineScope: ServiceProviderEngineScope): ?Object {
		if (_closed) {
			ThrowHelper.throwResourceClosedException()
		}
		let serviceAccessor = _serviceAccessors.getOrAdd(serviceIdentifier, _createServiceAccessor.getOrThrow())
		onResolve(serviceAccessor.callSite, serviceProviderEngineScope)
		
		if (serviceAccessor.realizedService.isNone()) {
			return None
		} else {
			return serviceAccessor.realizedService.getOrThrow()(serviceProviderEngineScope)
		}
	}

	private func validateService(descriptor: ServiceDescriptor) {
		// [Unsupported]
		// if (descriptor.ServiceType.IsGenericType && !descriptor.ServiceType.IsConstructedGenericType)
		// {
		// 	return;
		// }

		try {
			let callSite = callSiteFactory.getCallSite(descriptor, CallSiteChain());
			if (callSite.isSome())
			{
				onCreate(callSite.getOrThrow());
			}
		} catch (e: Exception) {
			throw InvalidOperationException("Error while validating the service descriptor '${descriptor}': ${e.message}");
		}
	}

	private func createServiceAccessor(serviceIdentifier: ServiceIdentifier) {
		let callSiteOption = callSiteFactory.getCallSite(serviceIdentifier, CallSiteChain())
		if (callSiteOption.isSome()) {
			let callSite = callSiteOption.getOrThrow()
			onCreate(callSite)

			// Optimize singleton case
			match (callSite.cache.location) {
				case CallSiteResultCacheLocation.Root =>
					let valueOption = CallSiteRuntimeResolver.instance.resolve(callSite, root)
					let serviceAccessor = ServiceAccessor()
					serviceAccessor.callSite = callSite
					serviceAccessor.realizedService = { _ => valueOption }
					return serviceAccessor
				case _ => ()
			}
			
			let realizedService = _engine.realizeService(callSite)
			let serviceAccessor = ServiceAccessor()
			serviceAccessor.callSite = callSite
			serviceAccessor.realizedService = realizedService
			return serviceAccessor
		}

		let serviceAccessor = ServiceAccessor()
		serviceAccessor.callSite = callSiteOption
		serviceAccessor.realizedService = { _ => None }
		return serviceAccessor
	}

	internal func replaceServiceAccessor(callSite: ServiceCallSite, accessor: (ServiceProviderEngineScope) -> ?Object) {
		var serviceAccessor = ServiceAccessor()
		serviceAccessor.callSite = callSite
		serviceAccessor.realizedService = accessor
		_serviceAccessors[ServiceIdentifier(callSite.key, callSite.serviceType)] = serviceAccessor
	}

	public func createScope(): IServiceScope {
		if (_closed) {
			ThrowHelper.throwResourceClosedException()
		}

		return ServiceProviderEngineScope(this, false)
	}
}

private class ServiceAccessor {
	private var _callSite: ?ServiceCallSite = None

	public mut prop callSite: ?ServiceCallSite {
		get() { _callSite }
		set(value) { _callSite = value }
	}

	private var _realizedService: ?(ServiceProviderEngineScope) -> ?Object = None

	public mut prop realizedService: ?(ServiceProviderEngineScope) -> ?Object {
		get() { _realizedService }
		set(value) { _realizedService = value }
	}
}

extend ConcurrentHashMap<ServiceIdentifier, ServiceAccessor> {
	public func getOrAdd(serviceIdentifier: ServiceIdentifier, factory: (ServiceIdentifier) -> ServiceAccessor): ServiceAccessor {
		let valueOption = get(serviceIdentifier)

		if (valueOption.isSome()) {
			return valueOption.getOrThrow()
		}
		
		let value = factory(serviceIdentifier)
		put(serviceIdentifier, value)
		return value
	}
}
