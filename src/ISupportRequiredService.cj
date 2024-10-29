package dependency_injection

import std.reflect.*

/*
	Optional contract used by ServiceProviderServiceExtensions.GetRequiredService{T}(IServiceProvider)
	to resolve services if supported by IServiceProvider.
*/
public interface ISupportRequiredService {
	/*
	Gets service of type serviceType from the IServiceProvider implementing
	this interface.

	serviceType: An object that specifies the type of service object to get.

	returns: A service object of type serviceType.
	
	Throws an exception if the IServiceProvider cannot create the object.
	*/
	func getRequiredService(serviceType: TypeInfo): Object
}
