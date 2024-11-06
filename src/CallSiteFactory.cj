package dependency_injection

import dependency_injection.abstractions.*
import dependency_injection.component_model.*
import dependency_injection.corelib.*
import std.collection.*
import std.collection.concurrent.*
import std.reflect.*
import std.sync.*

internal class CallSiteFactory <: IServiceProviderIsService & IServiceProviderIsKeyedService {
	private static const defaultSlot: Int = 0
	private let _descriptors: Array<ServiceDescriptor>
	private let _callSiteCache = ConcurrentHashMap<ServiceCacheKey, ServiceCallSite>()
	private let _descriptorLookup = HashMap<ServiceIdentifier, ServiceDescriptorCacheItem>()
	private let _callSiteLocks = ConcurrentHashMap<ServiceIdentifier, ReentrantMutex>()

	public init(descriptors: ICollection<ServiceDescriptor>) {
		_descriptors = IterableExtensions.toArray(descriptors)

		populate()
	}

	internal prop descriptors: Array<ServiceDescriptor> {
		get() { _descriptors }
	}

	private func populate() {
		for (descriptor in _descriptors) {
			let serviceType = descriptor.serviceType

			// [Unsupported]
			// if (serviceType.isGenericTypeDefinition) {
			// 	https://github.com/dotnet/runtime/blob/main/src/libraries/Microsoft.Extensions.DependencyInjection/src/ServiceLookup/CallSiteFactory.cs#L42
			// } else {
				let (sucess, implementationTypeOption) = descriptor.tryGetImplementationType()
				Debug.assert(implementationTypeOption.isSome())
				if (sucess) {
					let implementationType = implementationTypeOption.getOrThrow()

					if (/* [Unsupported] implementationType.isGenericTypeDefinition || */
						implementationType.isAbstract ||
						implementationType.isInterface) {
						throw ArgumentException(SR.format(SR.TypeCannotBeActivated, [implementationType.name, serviceType.name]))
					}
				}
			// }

			let cacheKey = ServiceIdentifier.fromDescriptor(descriptor)
			let cacheItemOption = _descriptorLookup.get(cacheKey)
			let cacheItem: ServiceDescriptorCacheItem
			if (cacheItemOption.isSome()) {
				cacheItem = cacheItemOption.getOrThrow()
			} else {
				cacheItem = ServiceDescriptorCacheItem()
			}
			_descriptorLookup[cacheKey] = cacheItem.add(descriptor)
		}
	}

	internal func getCallSite(serviceIdentifier: ServiceIdentifier, callSiteChain: CallSiteChain): ?ServiceCallSite {
		let site = _callSiteCache.get(ServiceCacheKey(serviceIdentifier, defaultSlot))
		if (site.isSome()) {
			return site.getOrThrow()
		} else {
			return createCallSite(serviceIdentifier, callSiteChain)
		}
	}

	internal func getCallSite(serviceDescriptor: ServiceDescriptor, callSiteChain: CallSiteChain): ?ServiceCallSite {
		let serviceIdentifier = ServiceIdentifier.fromDescriptor(serviceDescriptor)
		let descriptor = _descriptorLookup.get(serviceIdentifier)
		if (descriptor.isSome()) {
			return tryCreateExact(serviceDescriptor, serviceIdentifier, callSiteChain, descriptor.getOrThrow().getSlot(serviceDescriptor))
		}

		Debug.fail("_descriptorLookup didn't contain requested serviceDescriptor")
		return None
	}

	private func createCallSite(serviceIdentifier: ServiceIdentifier, callSiteChain: CallSiteChain): ?ServiceCallSite {
		// We need to lock the resolution process for a single service type at a time:
		// Consider the following:
		// C -> D -> A
		// E -> D -> A
		// Resolving C and E in parallel means that they will be modifying the callsite cache concurrently
		// to add the entry for C and E, but the resolution of D and A is synchronized
		// to make sure C and E both reference the same instance of the callsite.

		// This is to make sure we can safely store singleton values on the callsites themselves
		
		let callsiteLock = _callSiteLocks.getOrAdd(serviceIdentifier,  { _ => ReentrantMutex() })

		callsiteLock.lock()
		callSiteChain.checkCircularDependency(serviceIdentifier)

		let callSite = tryCreateExact(serviceIdentifier, callSiteChain) // ??
			// [Unsupported] tryCreateOpenGeneric(serviceIdentifier, callSiteChain) ??
			// [Unsupported] tryCreateIterable(serviceIdentifier, callSiteChain)
		callsiteLock.unlock()
		return callSite
	}

	private func tryCreateExact(serviceIdentifier: ServiceIdentifier, callSiteChain: CallSiteChain): ?ServiceCallSite {
		let descriptorOption = _descriptorLookup.get(serviceIdentifier)
		if (descriptorOption.isSome()) {
			let descriptor = descriptorOption.getOrThrow()
			return tryCreateExact(descriptor.last, serviceIdentifier, callSiteChain, defaultSlot)
		}

		if (serviceIdentifier.serviceKey.isSome()) {
			// Check if there is a registration with KeyedService.AnyKey
			let catchAllIdentifier = ServiceIdentifier(KeyedService.AnyKey, serviceIdentifier.serviceType)

			let descriptorOption = _descriptorLookup.get(catchAllIdentifier)
			if (descriptorOption.isSome()) {
				let descriptor = descriptorOption.getOrThrow()
				return tryCreateExact(descriptor.last, serviceIdentifier, callSiteChain, defaultSlot)
			}
		}

		return None
	}

	private func tryCreateExact(descriptor: ServiceDescriptor, serviceIdentifier: ServiceIdentifier, callSiteChain: CallSiteChain, slot: Int): ?ServiceCallSite {
		if (serviceIdentifier.serviceType == descriptor.serviceType) {
			let callSiteKey = ServiceCacheKey(serviceIdentifier, slot)
			let serviceCallSiteOption = _callSiteCache.get(callSiteKey)
			if (serviceCallSiteOption.isSome()) {
				return serviceCallSiteOption
			}

			let callSite: ServiceCallSite
			let lifetime = ResultCache(descriptor.lifetime, serviceIdentifier, slot)
			if (descriptor.hasImplementationInstance()) {
				callSite = ConstantCallSite(descriptor.serviceType, descriptor.getImplementationInstance().getOrThrow())
			} else if (!descriptor.isKeyedService && descriptor.implementationFactory.isSome()) {
				callSite = FactoryCallSite(lifetime, descriptor.serviceType, descriptor.implementationFactory.getOrThrow())
			} else if (descriptor.isKeyedService && descriptor.keyedImplementationFactory.isSome()) {
				callSite = FactoryCallSite(lifetime, descriptor.serviceType, serviceIdentifier.serviceKey.getOrThrow(), descriptor.keyedImplementationFactory.getOrThrow())
			} else if (descriptor.hasImplementationType()) {
				callSite = createConstructorCallSite(lifetime, serviceIdentifier, descriptor.getImplementationType().getOrThrow(), callSiteChain)
			} else {
				throw InvalidOperationException(SR.InvalidServiceDescriptor)
			}
			callSite.key = descriptor.serviceKey

			_callSiteCache[callSiteKey] = callSite
			return callSite
		}

		return None
	}

	private func createConstructorCallSite(
		lifetime: ResultCache,
		serviceIdentifier: ServiceIdentifier,
		implementationType: TypeInfo,
		callSiteChain: CallSiteChain
	): ConstructorCallSite {
		try {
			callSiteChain.add(serviceIdentifier, implementationType: implementationType)
			let constructors = ArrayList<ConstructorInfo>((implementationType as ClassTypeInfo).getOrThrow().constructors)

			var parameterCallSites: ?Array<ServiceCallSite> = None

			if (constructors.isEmpty()) {
				throw InvalidOperationException(SR.format(SR.NoConstructorMatch, [implementationType.name]))
			} else if (constructors.size == 1) {
				let constructor = constructors.iterator().first().getOrThrow()
				let parameters = constructor.parameters
				if (parameters.isEmpty()) {
					return ConstructorCallSite(lifetime, serviceIdentifier.serviceType, implementationType, constructor)
				}

				parameterCallSites = createArgumentCallSites(
					serviceIdentifier,
					implementationType,
					callSiteChain,
					parameters.toArray(),
					true
				).getOrThrow()

				return ConstructorCallSite(lifetime, serviceIdentifier.serviceType, implementationType, constructor, parameterCallSites.getOrThrow())
			}

			constructors.sortBy(stable: false, comparator: { a, b => a.parameters.size.compare(b.parameters.size) })

			var bestConstructor: ?ConstructorInfo = None
			var bestConstructorParameterTypes: ?HashSet<TypeInfo> = None
			for (i in 0..constructors.size) {
				let parameters = constructors[i].parameters

				let currentParameterCallSites = createArgumentCallSites(
					serviceIdentifier,
					implementationType,
					callSiteChain,
					parameters.toArray(),
					false
				)

				if (currentParameterCallSites.isSome()) {
					if (bestConstructor.isNone()) {
						bestConstructor = constructors[i]
						parameterCallSites = currentParameterCallSites
					} else {
						// Since we're visiting constructors in decreasing order of number of parameters,
						// we'll only see ambiguities or supersets once we've seen a 'bestConstructor'.

						if (bestConstructorParameterTypes.isNone()) {
							bestConstructorParameterTypes = HashSet()
							for (p in bestConstructor.getOrThrow().parameters) {
								bestConstructorParameterTypes.getOrThrow().put(p.typeInfo)
							}
						}

						for (p in parameters) {
							if (!bestConstructorParameterTypes.getOrThrow().contains(p.typeInfo)) {
								// Ambiguous match exception
								throw InvalidOperationException(String.join([
									SR.format(SR.AmbiguousConstructorException, [implementationType.name]),
									bestConstructor.getOrThrow().toString(),
									constructors[i].toString()
								], delimiter: Environment.newLine))
							}
						}
					}
				}
			}

			if (bestConstructor.isNone()) {
				throw InvalidOperationException(SR.format(SR.UnableToActivateTypeException, [implementationType.name]))
			} else {
				Debug.assert(parameterCallSites.isSome())
				return ConstructorCallSite(lifetime, serviceIdentifier.serviceType, implementationType, bestConstructor.getOrThrow(), parameterCallSites.getOrThrow())
			}
		} finally {
			callSiteChain.remove(serviceIdentifier)
		}
	}

	/*
	returns: Not None if throwIfCallSiteNotFound is true
	*/
	private func createArgumentCallSites(
		serviceIdentifier: ServiceIdentifier,
		implementationType: TypeInfo,
		callSiteChain: CallSiteChain,
		parameters: Array<ParameterInfo>,
		throwIfCallSiteNotFound: Bool
	): ?Array<ServiceCallSite> {
		var parameterCallSites = ArrayList<ServiceCallSite>()

		for (index in 0..parameters.size) {
			var callSite: ?ServiceCallSite = None
			var isKeyedParameter = false
			let parameterType = parameters[index].typeInfo
			for (annotation in parameterType.annotations) {
				if (serviceIdentifier.serviceKey.isSome() && annotation is ServiceKey) {
					// Check if the parameter type matches
					if (parameterType != TypeInfo.of(serviceIdentifier.serviceKey)) {
						throw InvalidOperationException(SR.InvalidServiceKeyType)
					}
					callSite = ConstantCallSite(parameterType, serviceIdentifier.serviceKey.getOrThrow())
					break
				}
				let keyed = annotation as FromKeyedServices
				if (keyed.isSome()) {
					let parameterSvcId = ServiceIdentifier(keyed.getOrThrow().key, parameterType)
					callSite = getCallSite(parameterSvcId, callSiteChain)
					isKeyedParameter = true
					break
				}
			}

			if (!isKeyedParameter) {
				if (callSite.isNone()) {
					callSite = getCallSite(ServiceIdentifier.fromServiceType(parameterType), callSiteChain)
				}
			}

			if (callSite.isNone()) {
				let (_, defaultValue) = ParameterDefaultValue.tryGetDefaultValue(parameters[index])
				callSite = ConstantCallSite(parameterType, defaultValue)
			}

			if (callSite.isNone()) {
				if (throwIfCallSiteNotFound) {
					throw InvalidOperationException(SR.format(SR.CannotResolveService, [parameterType.name, implementationType.name]))
				}

				return None
			}

			parameterCallSites.append(callSite.getOrThrow())
		}

		return parameterCallSites.toArray()
	}

	public func add(serviceIdentifier: ServiceIdentifier, serviceCallSite: ServiceCallSite) {
		_callSiteCache[ServiceCacheKey(serviceIdentifier, defaultSlot)] = serviceCallSite
	}

	public override func isService(serviceType: TypeInfo): Bool {
		isService(ServiceIdentifier.fromServiceType(serviceType))
	}

	public override func isKeyedService(serviceType: TypeInfo, key: ?IHashableEquatableToString<?Any>): Bool {
		isService(ServiceIdentifier(key, serviceType))
	}

	internal func isService(serviceIdentifier: ServiceIdentifier): Bool {
		let serviceType = serviceIdentifier.serviceType
		
		if (_descriptorLookup.contains(serviceIdentifier)) {
			return true
		}

		if (serviceIdentifier.serviceKey.isSome() && _descriptorLookup.contains(ServiceIdentifier(KeyedService.AnyKey, serviceType))) {
			return true
		}
		
		// These are the built in service types that aren't part of the list of service descriptors
		// If you update these make sure to also update the code in ServiceProvider.ctor
		return serviceType == TypeInfo.of<IServiceProvider>() ||
			serviceType == TypeInfo.of<IServiceScopeFactory>() ||
			serviceType == TypeInfo.of<IServiceProviderIsService>() ||
			serviceType == TypeInfo.of<IServiceProviderIsKeyedService>()
	}

	// private static func keysMatch(key1: ?HashableEquatable<?Any>, key2: ?HashableEquatable<?Any>): Bool {
	// 	if (key1.isNone() && key2.isNone()) {
	// 		return true
	// 	}

	// 	if (key1.isSome() && key2.isSome()) {
	// 		let key1_ = key1.getOrThrow()
	// 		let key2_ = key2.getOrThrow()
	// 		return key1_ == key2_ ||
	// 			key1_ == KeyedService.AnyKey ||
	// 			key2_ == KeyedService.AnyKey
	// 	}

	// 	return false
	// }
}

private struct ServiceDescriptorCacheItem {
	private var _item: ?ServiceDescriptor = None

	private var _items: ?ArrayList<ServiceDescriptor> = None

	public prop last: ServiceDescriptor {
		get() {
			if (_items.isSome() && !_items.getOrThrow().isEmpty()) {
				return _items.getOrThrow()[_items.getOrThrow().size - 1]
			}
			
			Debug.assert(_item.isSome())
			return _item.getOrThrow()
		}
	}

	public prop count: Int {
		get() {
			if (_item.isNone()) {
				Debug.assert(_items.isSome())
				return 0
			}

			if (_items.isSome()) {
				return 1 + _items.getOrThrow().size
			} else {
				return 1
			}
		}
	}

	public operator func [](index: Int): ServiceDescriptor {
		if (index >= count) {
			throw IndexOutOfBoundsException("index")
		}

		if (index == 0) {
			return _item.getOrThrow()
		}

		return _items.getOrThrow()[index - 1]
	}

	public func getSlot(descriptor: ServiceDescriptor): Int {
		if (_item.isSome() && refEq(_item.getOrThrow(), descriptor)) {
			return count - 1
		}

		if (_items.isSome()) {
			var index = -1
			for (i in 0.._items.getOrThrow().size) {
				if (refEq(_items.getOrThrow()[i], descriptor)) {
					index = i
					break
				}
			}

			if (index != -1) {
				return _items.getOrThrow().size - (index + 1)
			}
		}

		throw InvalidOperationException(SR.ServiceDescriptorNotExist)
	}

	public func add(descriptor: ServiceDescriptor) {
		var newCacheItem = ServiceDescriptorCacheItem()
		if (_item.isNone()) {
			newCacheItem._item = descriptor
		} else {
			newCacheItem._item = _item.getOrThrow()
			newCacheItem._items = _items ?? ArrayList<ServiceDescriptor>()
			newCacheItem._items.getOrThrow().append(descriptor)
		}
		return newCacheItem
	}
}

extend ConcurrentHashMap<ServiceIdentifier, ReentrantMutex> {
	public func getOrAdd(serviceIdentifier: ServiceIdentifier, factory: (ServiceIdentifier) -> ReentrantMutex): ReentrantMutex {
		let valueOption = get(serviceIdentifier)

		if (valueOption.isSome()) {
			return valueOption.getOrThrow()
		}
		
		let value = factory(serviceIdentifier)
		put(serviceIdentifier, value)
		return value
	}
}
