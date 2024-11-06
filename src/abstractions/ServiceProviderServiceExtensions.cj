package dependency_injection.abstractions

import dependency_injection.component_model.*
import dependency_injection.corelib.*
import std.reflect.*

/*
	Extension methods for getting services from an IServiceProvider.
*/
public class ServiceProviderServiceExtensions {
	/*
	Get service of type T from the IServiceProvider.

	T: The type of service object to get.

	provider: The IServiceProvider to retrieve the service object from.

	returns: A service object of type T or None if there is no such service.
	*/
	public static func getService1<T>(provider: IServiceProvider): ?T {
		return provider.getService(TypeInfo.of<T>()) as T
	}

	/*
	Get service of type serviceType from the IServiceProvider.

	provider: The IServiceProvider to retrieve the service object from.
	serviceType: An object that specifies the type of service object to get.

	returns: A service object of type serviceType.

	exception: InvalidOperationException: There is no service of type serviceType.
	*/
	public static func getRequiredService(provider: IServiceProvider, serviceType: TypeInfo): Object {
		if (let Some(requiredServiceSupportingProvider) <- (provider as ISupportRequiredService)) {
			return requiredServiceSupportingProvider.getRequiredService(serviceType)
		}
		
		let service = provider.getService(serviceType)
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

	exception: InvalidOperationException: There is no service of type T.
	*/
	public static func getRequiredService1<T>(provider: IServiceProvider): T {
		return (getRequiredService(provider, TypeInfo.of<T>()) as T).getOrThrow()
	}

	/*
	Get an enumeration of services of type T from the IServiceProvider.

	T: The type of service object to get.

	provider: The IServiceProvider to retrieve the services from.

	returns: An enumeration of services of type T.
	*/
	public static func getServices1<T>(provider: IServiceProvider): Iterable<T> {
		throw NotImplementedException()
	}
	
	/*
	Get an enumeration of services of type serviceType from the IServiceProvider.

	provider: The IServiceProvider to retrieve the services from.
	serviceType: An object that specifies the type of service object to get.

	returns: An enumeration of services of type serviceType.
	*/
	public static func getServices(provider: IServiceProvider, serviceType: TypeInfo): Iterable<?Object> {
		throw NotImplementedException()
	}

	/*
	Creates a new IServiceScope that can be used to resolve scoped services.

	provider: The IServiceProvider to create the scope from.

	returns: A IServiceScope that can be used to resolve scoped services.
	*/
	public static func createScope<T>(provider: IServiceProvider): IServiceScope {
		return getRequiredService1<IServiceScopeFactory>(provider).createScope()
	}
}
