package dependency_injection

import dependency_injection.component_model.*
import std.reflect.*

internal class ServiceProviderCallSite <: ServiceCallSite {
	public init() {
		super(ResultCache.none(TypeInfo.of<IServiceProvider>()))
	}

	private let _serviceType: TypeInfo = TypeInfo.of<IServiceProvider>()

	public override prop serviceType: TypeInfo {
		get() { _serviceType }
	}

	private let _implementationType: TypeInfo = TypeInfo.of<ServiceProvider>()

	public override prop implementationType: ?TypeInfo {
		get() { _implementationType }
	}

	public override prop kind: CallSiteKind {
		get() { CallSiteKind.ServiceProvider }
	}
}
