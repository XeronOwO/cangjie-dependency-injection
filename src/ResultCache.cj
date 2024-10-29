package dependency_injection

import std.reflect.*

internal struct ResultCache {
	public static func none(serviceType: TypeInfo) {
		let cacheKey = ServiceCacheKey(ServiceIdentifier.fromServiceType(serviceType), 0)
		return ResultCache(CallSiteResultCacheLocation.None, cacheKey)
	}

	internal init(lifetime: CallSiteResultCacheLocation, cacheKey: ServiceCacheKey) {
		_location = lifetime
		_key = cacheKey
	}

	public init(lifetime: ServiceLifetime, serviceIdentifier: ServiceIdentifier, slot: Int) {
		match (lifetime) {
			case ServiceLifetime.Singleton => _location = CallSiteResultCacheLocation.Root
			case ServiceLifetime.Scoped => _location = CallSiteResultCacheLocation.Scope
			case ServiceLifetime.Transient => _location = CallSiteResultCacheLocation.Resource
			// case _ => _location = CallSiteResultCacheLocation.None
		}
		_key = ServiceCacheKey(serviceIdentifier, slot)
	}

	private let _location: CallSiteResultCacheLocation

	public prop location: CallSiteResultCacheLocation {
		get() { _location }
	}

	private let _key: ServiceCacheKey

	public prop key: ServiceCacheKey {
		get() { _key }
	}
}
