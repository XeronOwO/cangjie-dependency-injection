package dependency_injection

import std.reflect.*
import std.sync.*

/*
	Summary description for ServiceCallSite
*/
internal abstract class ServiceCallSite {
	protected init(cache: ResultCache) {
		_cache = cache
		_value = None
		_key = None
	}

	public open prop serviceType: TypeInfo

	public open prop implementationType: ?TypeInfo
	
	public open prop kind: CallSiteKind

	private let _cache: ResultCache

	public prop cache: ResultCache {
		get() { _cache }
	}

	private var _value: ?Any

	public mut prop value: ?Any {
		get() { _value }
		set(value) { _value = value }
	}

	private var _key: ?HashableEquatable<?Any>

	public mut prop key: ?HashableEquatable<?Any> {
		get() { _key }
		set(value) { _key = value }
	}

	public func captureResource(): Bool {
		return implementationType.isNone() ||
			TypeInfo.of<Resource>().isSubtypeOf(implementationType.getOrThrow())
	}

	private let _sync = ReentrantMutex()

	public prop sync: ReentrantMutex {
		get() { _sync }
	}
}
