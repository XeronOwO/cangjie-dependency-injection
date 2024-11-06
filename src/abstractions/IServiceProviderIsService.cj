package dependency_injection.abstractions

import std.reflect.*

/*
	Provides methods to determine if the specified type is available from the IServiceProvider.
*/
public interface IServiceProviderIsService {
	/*
	Determines if the specified service type is available from the IServiceProvider.

	serviceType: An object that specifies the type of service object to test.

	returns: true if the specified service is a available, false if it is not.
	*/
	func isService(serviceType: TypeInfo): Bool
}
