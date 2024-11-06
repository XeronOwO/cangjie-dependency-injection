package dependency_injection

import dependency_injection.abstractions.*

/*
	Extension methods for building a ServiceProvider from an IServiceCollection.
*/
public class ServiceCollectionContainerBuilderExtensions {
	/*
	Creates a ServiceProvider containing services from the provided IServiceCollection.

	services: The IServiceCollection containing service descriptors.

	returns: The ServiceProvider.
	*/
	public static func buildServiceProvider(
		services: IServiceCollection
	): ServiceProvider {
		return ServiceProvider(services, ServiceProviderOptions.default)
	}

	/*
	Creates a ServiceProvider containing services from the provided IServiceCollection
	optionally enabling scope validation.

	services: The IServiceCollection containing service descriptors.
	validateScopes: true to perform check verifying that scoped services never gets resolved from root provider; otherwise false.

	returns: The ServiceProvider.
	*/
	public static func buildServiceProvider(
		services: IServiceCollection,
		validateScopes: Bool
	): ServiceProvider {
		var options = ServiceProviderOptions()
		options.validateScopes = validateScopes
		return ServiceProvider(services, options)
	}

	/*
	Creates a ServiceProvider containing services from the provided IServiceCollection
	optionally enabling scope validation.

	services: The IServiceCollection containing service descriptors.
	options: Configures various service provider behaviors.

	returns: The ServiceProvider.
	*/
	public static func buildServiceProvider(
		services: IServiceCollection,
		options: ServiceProviderOptions
	): ServiceProvider {
		return ServiceProvider(services, options)
	}
}
