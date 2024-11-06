package dependency_injection

import dependency_injection.corelib.*
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
	
	public init(cache: ResultCache, itemType: TypeInfo, serviceCallSites: Array<ServiceCallSite>) {
		super(cache)

		_itemType = itemType
		_serviceCallSites = serviceCallSites
	}

	public override prop serviceType: TypeInfo {
		get() { throw NotImplementedException() }
	}

	public override prop implementationType: ?TypeInfo {
		get() { throw NotImplementedException() }
	}

	public override prop kind: CallSiteKind {
		get() { CallSiteKind.Iterable }
	}
}
