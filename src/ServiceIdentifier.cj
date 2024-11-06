package dependency_injection

import dependency_injection.abstractions.*
import dependency_injection.corelib.*
import std.reflect.*

internal struct ServiceIdentifier <: Hashable & Equatable<ServiceIdentifier> & ToString {
	private let _serviceKey: ?IHashableEquatableToString<?Any>

	public prop serviceKey: ?IHashableEquatableToString<?Any> {
		get() { _serviceKey }
	}

	private let _serviceType: TypeInfo

	public prop serviceType: TypeInfo {
		get() { _serviceType }
	}

	public init(serviceType: TypeInfo) {
		_serviceKey = None
		_serviceType = serviceType
	}

	public init(serviceKey: ?IHashableEquatableToString<?Any>, serviceType: TypeInfo) {
		_serviceKey = serviceKey
		_serviceType = serviceType
	}

	public static func fromDescriptor(descriptor: ServiceDescriptor): ServiceIdentifier {
		return ServiceIdentifier(descriptor.serviceKey, descriptor.serviceType)
	}

	public static func fromServiceType(serviceType: TypeInfo): ServiceIdentifier {
		return ServiceIdentifier(serviceType)
	}

	public override operator func ==(other: ServiceIdentifier): Bool {
		if (serviceKey.isNone() && other.serviceKey.isNone()) {
			return serviceType == other.serviceType
		}
		else if (serviceKey.isSome() && other.serviceKey.isSome()) {
			return serviceType == other.serviceType && serviceKey.getOrThrow() == other.serviceKey.getOrThrow()
		}
		return false
	}

	public override func hashCode(): Int64 {
		if (serviceKey.isNone()) {
			return serviceType.hashCode()
		} else {
			return (serviceKey.getOrThrow().hashCode() * 397) ^ serviceType.hashCode()
		}
	}

	public prop isConstructedGenericType: Bool {
		get() { throw NotImplementedException() }
	}

	public func getGenericTypeDefinition(): ServiceIdentifier {
		throw NotImplementedException()
	}

	public override func toString(): String {
		if (serviceKey.isNone()) {
			return serviceType.toString()
		}

		return "(${serviceKey}, ${serviceType})"
	}
}
