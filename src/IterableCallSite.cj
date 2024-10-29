package dependency_injection

import std.reflect.*

internal class IterableCallSite <: ServiceCallSite {
	private let _itemType: TypeInfo

	internal prop itemType: TypeInfo {
		get() { _itemType }
	}

	private let _serviceCallSites: Array<ServiceCallSite>

	internal prop serviceCallSites: Array<ServiceCallSite> {
		get() { _serviceCallSites }
	}

	public init(cache: ResultCache, itemType: TypeInfo, serviceType: TypeInfo, implementationType: TypeInfo, serviceCallSites: Array<ServiceCallSite>) {
		super(cache)

		_itemType = itemType
		_serviceType = serviceType
		_implementationType = implementationType
		_serviceCallSites = serviceCallSites
	}

	private let _serviceType: TypeInfo

	public override prop serviceType: TypeInfo {
		get() { _serviceType }
	}

	private let _implementationType: TypeInfo

	public override prop implementationType: ?TypeInfo {
		get() { _implementationType }
	}

	public override prop kind: CallSiteKind {
		get() { CallSiteKind.Iterable }
	}

	public static func make<T>(cache: ResultCache, serviceCallSites: Array<ServiceCallSite>): IterableCallSite {
		return IterableCallSite(cache, TypeInfo.of<T>(), TypeInfo.of<Iterable<T>>(), TypeInfo.of<Array<T>>(), serviceCallSites)
	}
}
