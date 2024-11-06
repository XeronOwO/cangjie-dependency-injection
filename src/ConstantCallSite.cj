package dependency_injection

import dependency_injection.abstractions.*
import dependency_injection.corelib.*
import std.reflect.*

internal class ConstantCallSite <: ServiceCallSite {
	private let _serviceType: TypeInfo

	internal prop defaultValue: ?Any {
		get() { value }
	}

	public init(serviceType: TypeInfo, defaultValue: ?Any) {
		super(ResultCache.none(serviceType))

		_serviceType = serviceType
		if (defaultValue.isSome() && !serviceType.isInstanceOfType(defaultValue.getOrThrow())) {
			throw ArgumentException(SR.format(SR.ConstantCantBeConvertedToServiceType, [TypeInfo.of(defaultValue.getOrThrow()).name, serviceType.name]))
		}

		value = defaultValue
	}

	public override prop serviceType: TypeInfo {
		get() { _serviceType }
	}

	public override prop implementationType: ?TypeInfo {
		get() {
			if (defaultValue.isSome()) {
				return TypeInfo.of(defaultValue)
			}
			return _serviceType
		}
	}

	public override prop kind: CallSiteKind {
		get() { CallSiteKind.Constant }
	}
}
