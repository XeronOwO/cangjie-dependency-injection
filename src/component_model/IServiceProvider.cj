package dependency_injection.component_model

import std.reflect.*

public interface IServiceProvider {
	func getService(serviceType: TypeInfo): ?Object
}
