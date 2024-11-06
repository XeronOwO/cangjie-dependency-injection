package dependency_injection.abstractions

import dependency_injection.component_model.*

/*
	Provides an extension point for creating a container specific builder and an IServiceProvider.
*/
public interface IServiceProviderFactory<TContainerBuilder> {
	/*
	Creates a container builder from an IServiceCollection.

	services: The collection of services.

	returns: A container builder that can be used to create an IServiceProvider.
	*/
	func CreateBuilder(services: IServiceCollection): TContainerBuilder

	/*
	Creates an IServiceProvider from the container builder.

	containerBuilder: The container builder.

	returns: An IServiceProvider instance.
	*/
	func CreateServiceProvider(containerBuilder: TContainerBuilder): IServiceProvider
}
