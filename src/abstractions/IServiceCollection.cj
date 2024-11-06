package dependency_injection.abstractions

import dependency_injection.corelib.*

/*
	Specifies the contract for a collection of service descriptors.
*/
public interface IServiceCollection <: IList<ServiceDescriptor> {
}
