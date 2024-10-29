package dependency_injection

import dependency_injection.exceptions.*
import dependency_injection.resources.*
import std.reflect.*

public interface IServiceProvider {
	func getService(serviceType: TypeInfo): ?Object

	/*
	Get service of type T from the IServiceProvider.

	T: The type of service object to get.

	provider: The IServiceProvider to retrieve the service object from.

	returns: A service object of type T or null if there is no such service.
	*/
	static func getService1<T>(provider: IServiceProvider): ?T {
		let service = provider.getService(TypeInfo.of<T>())
		if (service.isNone()) {
			return None
		}
		return service.getOrThrow() as T
	}

	/*
	Get service of type serviceType from the IServiceProvider.

	provider: The IServiceProvider to retrieve the service object from.
	serviceType: An object that specifies the type of service object to get.

	returns: A service object of type serviceType.
	*/
	func getRequiredService(serviceType: TypeInfo): Object {
		let requiredServiceSupportingProvider = this as ISupportRequiredService
		if (requiredServiceSupportingProvider.isSome()) {
			return requiredServiceSupportingProvider.getOrThrow().getRequiredService(serviceType)
		}

		let service = getService(serviceType)
		if (service.isNone()) {
			throw InvalidOperationException(SR.format(SR.NoServiceRegistered, serviceType))
		}

		return service.getOrThrow()
	}

	/*
	Get service of type T from the IServiceProvider.

	T: The type of service object to get.
	provider: The IServiceProvider to retrieve the service object from.
	returns: A service object of type T.
	*/
	static func getRequiredService1<T>(provider: IServiceProvider): T {
		return (provider.getRequiredService(TypeInfo.of<T>()) as T).getOrThrow()
	}
	
	/*
	Creates a new AsyncServiceScope that can be used to resolve scoped services.

	provider: The IServiceProvider to create the scope from.

	returns: An AsyncServiceScope that can be used to resolve scoped services.
	*/
	func createScope(): IServiceScope {
		return getRequiredService1<IServiceScopeFactory>(this).createScope()
	}

	/*
	Get service of type T from the IServiceProvider.

	T: The type of service object to get.
	provider: The IServiceProvider to retrieve the service object from.
	serviceKey: An object that specifies the key of service object to get.
	returns: A service object of type T or null if there is no such service.
	*/
	static func getKeyedService1<T>(provider: IServiceProvider, serviceKey: ?HashableEquatable<?Any>): ?T {
		let keyedServiceProvider = provider as IKeyedServiceProvider
		if (keyedServiceProvider.isSome()) {
			let service = keyedServiceProvider.getOrThrow().getKeyedService(TypeInfo.of<T>(), serviceKey)
			if (service.isNone()) {
				return None
			}
			return service.getOrThrow() as T
		}

		throw InvalidOperationException(SR.KeyedServicesNotSupported)
	}

	/*
	Get service of type serviceType from the IServiceProvider.

	provider: The IServiceProvider to retrieve the service object from.
	serviceType: An object that specifies the type of service object to get.
	serviceKey: An object that specifies the key of service object to get.
	returns: A service object of type serviceType or null if there is no such service.
	*/
	func getKeyedService(serviceType: TypeInfo, serviceKey: ?HashableEquatable<?Any>): ?Object {
		let keyedServiceProvider = this as IKeyedServiceProvider
		if (keyedServiceProvider.isSome()) {
			return keyedServiceProvider.getOrThrow().getKeyedService(serviceType, serviceKey)
		}

		throw InvalidOperationException(SR.KeyedServicesNotSupported)
	}
	
	/*
	Get service of type serviceType from the IServiceProvider.

	serviceType: An object that specifies the type of service object to get.
	serviceKey: An object that specifies the key of service object to get.

	returns: A service object of type serviceType.
	*/
	func getRequiredKeyedService(serviceType: TypeInfo, serviceKey: ?HashableEquatable<?Any>): Object {
		let keyedServiceProvider = this as IKeyedServiceProvider
		if (keyedServiceProvider.isSome()) {
			return keyedServiceProvider.getOrThrow().getKeyedService(serviceType, serviceKey).getOrThrow()
		}

		throw InvalidOperationException(SR.KeyedServicesNotSupported)
	}

	/*
	Get service of type T from the IServiceProvider.

	T: The type of service object to get.

	provider: The IServiceProvider to retrieve the service object from.
	serviceKey: An object that specifies the key of service object to get.

	returns: A service object of type T.
	*/
	static func getRequiredKeyedService1<T>(provider: IServiceProvider, serviceKey: ?HashableEquatable<?Any>): T {
		return (provider.getRequiredKeyedService(TypeInfo.of<T>(), serviceKey) as T).getOrThrow()
	}
}
