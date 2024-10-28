package dependency_inject

import std.reflect.*

internal struct ServiceIdentifier <: Hashable & Equatable<ServiceIdentifier> {
	private let _serviceKey: ?HashableEquatable<?Any>

	public prop serviceKey: ?HashableEquatable<?Any> {
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

	public init(serviceKey: ?HashableEquatable<?Any>, serviceType: TypeInfo) {
		_serviceKey = serviceKey
		_serviceType = serviceType
	}

	public static func fromDescriptor(descriptor: ServiceDescriptor): ServiceIdentifier {
		return ServiceIdentifier(descriptor.serviceKey, descriptor.serviceType)
	}

	public static func fromServiceType(serviceType: TypeInfo): ServiceIdentifier {
		return ServiceIdentifier(serviceType)
	}

	public operator func ==(rhs: ServiceIdentifier): Bool {
		if (serviceKey.isNone() && rhs.serviceKey.isNone()) {
			return serviceType == rhs.serviceType
		}
		else if (serviceKey.isSome() && rhs.serviceKey.isSome()) {
			return serviceType == rhs.serviceType && serviceKey.getOrThrow() == rhs.serviceKey.getOrThrow()
		}
		return false
	}

	public func hashCode(): Int64 {
		if (serviceKey.isNone()) {
			return serviceType.hashCode()
		} else {
			return (serviceKey.getOrThrow().hashCode() * 397) ^ serviceType.hashCode()
		}
	}
}
