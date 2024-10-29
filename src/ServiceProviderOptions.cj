package dependency_injection

/*
	Options for configuring various behaviors of the default IServiceProvider implementation.
*/
public class ServiceProviderOptions {
	private static let _default: ServiceProviderOptions = ServiceProviderOptions()

	/*
	Avoid allocating objects in the default case
	*/
	internal static prop default: ServiceProviderOptions {
		get() { _default }
	}

	private var _validateScopes: Bool = false

	/*
	Gets or sets a value that indicates whether validation is performed to ensure that scoped services are never resolved from the root provider.
	*/
	public mut prop validateScopes: Bool {
		get() { _validateScopes }
		set(value) { _validateScopes = value }
	}

	private var _validateOnBuild: Bool = false

	/*
	Gets or sets a value that indicates whether validation is performed to ensure all services can be created when BuildServiceProvider(IServiceCollection,ServiceProviderOptions) is called.

	Open generics services aren't validated.
	*/
	public mut prop validateOnBuild: Bool {
		get() { _validateOnBuild }
		set(value) { _validateOnBuild = value }
	}
}
