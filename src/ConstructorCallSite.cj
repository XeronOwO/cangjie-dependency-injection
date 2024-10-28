package dependency_inject

import dependency_inject.exceptions.*
import dependency_inject.resources.*
import std.reflect.*

internal class ConstructorCallSite <: ServiceCallSite {
	private let _constructorInfo: ConstructorInfo

	public prop constructorInfo: ConstructorInfo {
		get() { _constructorInfo }
	}

	private let _parameterCallSites: Array<ServiceCallSite>

	public prop parameterCallSites: Array<ServiceCallSite> {
		get() { _parameterCallSites }
	}

	public init(cache: ResultCache, serviceType: TypeInfo, implementationType: TypeInfo, constructorInfo: ConstructorInfo) {
		this(cache, serviceType, implementationType, constructorInfo, Array<ServiceCallSite>())
	}

	public init(cache: ResultCache, serviceType: TypeInfo, implementationType: TypeInfo, constructorInfo: ConstructorInfo, parameterCallSites: Array<ServiceCallSite>) {
		super(cache)

		if (!implementationType.isSubtypeOf(serviceType)) {
			throw ArgumentException(SR.format(SR.ImplementationTypeCantBeConvertedToServiceType, [implementationType.name, serviceType.name]))
		}
		
		_serviceType = serviceType
		_constructorInfo = constructorInfo
		_implementationType = implementationType
		_parameterCallSites = parameterCallSites
	}

	private let _serviceType: TypeInfo

	public override prop serviceType: TypeInfo {
		get() { _serviceType }
	}

	private let _implementationType: ?TypeInfo

	public override prop implementationType: ?TypeInfo {
		get() { _implementationType }
	}

	public override prop kind: CallSiteKind {
		get() { CallSiteKind.Constructor }
	}
}
