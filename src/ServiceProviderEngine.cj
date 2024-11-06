package dependency_injection

internal abstract class ServiceProviderEngine {
	public open func realizeService(callSite: ServiceCallSite): (ServiceProviderEngineScope) -> ?Object
}
