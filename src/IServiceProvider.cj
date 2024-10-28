package dependency_inject

import dependency_inject.exceptions.*
import dependency_inject.resources.*
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
		provider.getService(TypeInfo.of<T>()).getOrThrow() as T
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
}
