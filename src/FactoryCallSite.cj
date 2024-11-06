package dependency_injection

import dependency_injection.abstractions.*
import dependency_injection.component_model.*
import std.reflect.*

internal class FactoryCallSite <: ServiceCallSite {
	private let _factory: (IServiceProvider) -> Object

	public prop factory: (IServiceProvider) -> Object {
		get() { _factory }
	}

	public init(cache: ResultCache, serviceType: TypeInfo, factory: (IServiceProvider) -> Object) {
		super(cache)
		
		_factory = factory
		_serviceType = serviceType
	}

	public init(cache: ResultCache, serviceType: TypeInfo, serviceKey: ?IHashableEquatableToString<?Any>, factory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> Object) {
		super(cache)
		
		_factory = { sp => factory(sp, serviceKey) }
		_serviceType = serviceType
	}

	private let _serviceType: TypeInfo

	public override prop serviceType: TypeInfo {
		get() { _serviceType }
	}

	public override prop implementationType: ?TypeInfo {
		get() { None }
	}

	public override prop kind: CallSiteKind {
		get() { CallSiteKind.Factory }
	}
}
