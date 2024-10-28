package dependency_inject

import std.reflect.*

internal struct ServiceCacheKey <: Hashable & Equatable<ServiceCacheKey> {
	private let _serviceIdentifier: ServiceIdentifier

	/*
	Type of service being cached
	*/
	public prop serviceIdentifier: ServiceIdentifier {
		get() { _serviceIdentifier}
	}

	private let _slot: Int

	/*
	Reverse index of the service when resolved in <c>IEnumerable&lt;Type&gt;</c> where default instance gets slot 0.
	For example for service collection
	 IService Impl1
	 IService Impl2
	 IService Impl3
	We would get the following cache keys:
	 Impl1 2
	 Impl2 1
	 Impl3 0
	*/
	public prop slot: Int {
		get() { _slot}
	}

	public init(key: HashableEquatable<?Any>, typ: TypeInfo, slot: Int) {
		_serviceIdentifier = ServiceIdentifier(key, typ)
		_slot = slot
	}

	public init(typ: ServiceIdentifier, slot: Int) {
		_serviceIdentifier = typ
		_slot = slot
	}

	public operator func ==(rhs: ServiceCacheKey): Bool {
		return _serviceIdentifier == rhs._serviceIdentifier && _slot == rhs._slot
	}

	public func hashCode(): Int64 {
		return (serviceIdentifier.hashCode() * 397) ^ slot
	}
}
