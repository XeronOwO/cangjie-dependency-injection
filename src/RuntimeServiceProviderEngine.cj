package dependency_inject

internal class RuntimeServiceProviderEngine <: ServiceProviderEngine {
	private static let _instance = RuntimeServiceProviderEngine()

	public static prop instance: RuntimeServiceProviderEngine {
		get() { _instance }
	}

	private init() {
	}

	public override func realizeService(callSite: ServiceCallSite): (ServiceProviderEngineScope) -> ?Any {
		return {
			scope => CallSiteRuntimeResolver.instance.resolve(callSite, scope)
		}
	}
}
