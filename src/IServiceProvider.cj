package dependency_inject

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
}
