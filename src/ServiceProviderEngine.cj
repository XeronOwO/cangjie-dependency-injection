package dependency_inject

internal abstract class ServiceProviderEngine {
	public open func realizeService(callSite: ServiceCallSite): (ServiceProviderEngineScope) -> ?Any
}
