package dependency_inject

import std.reflect.*

/*
	Provides methods to determine if the specified type with the specified service key is available
	from the IServiceProvider.
*/
public interface IServiceProviderIsKeyedService <: IServiceProviderIsService {
	/*
	Determines if the specified service type with the specified service key is available from the
	IServiceProvider.

	serviceType: An object that specifies the type of service object to test.
	serviceKey: The ServiceKey of the service.
	*/
	func isKeyedService(serviceType: TypeInfo, serviceKey: ?HashableEquatable<?Any>): Bool
}
