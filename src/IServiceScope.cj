package dependency_inject

/*
	Defines a disposable service scope.

	The Resource method ends the scope lifetime. Once Dispose
	is called, any scoped services that have been resolved from
	ServiceProvider will be disposed.
*/
public interface IServiceScope <: Resource {
	/*
	Gets the IServiceProvider used to resolve dependencies from the scope.
	*/
	prop serviceProvider: IServiceProvider
}
