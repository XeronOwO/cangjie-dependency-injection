package dependency_injection.abstractions

import dependency_injection.component_model.*

/*
	Defines a resource service scope.

	The close method ends the scope lifetime. Once close
	is called, any scoped services that have been resolved from
	ServiceProvider will be 
	closed.
*/
public interface IServiceScope <: Resource {
	/*
	Gets the IServiceProvider used to resolve dependencies from the scope.
	*/
	prop serviceProvider: IServiceProvider
}
