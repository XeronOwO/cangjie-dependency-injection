package dependency_injection

import dependency_injection.abstractions.*
import dependency_injection.component_model.*
import dependency_injection.corelib.*
import std.collection.*
import std.reflect.*
import std.sync.*

internal class ServiceProviderEngineScope <: IServiceScope & IServiceProvider & IKeyedServiceProvider & Resource & IServiceScopeFactory {
	// For testing and debugging only
	internal prop resources: ArrayList<Any> {
		get() {
			if (_resources.isNone()) {
				return ArrayList<Any>()
			}
			return _resources.getOrThrow()
		}
	}

	private var _closed: Bool = false

	private var _resources: ?ArrayList<Any> = None

	public init(provider: ServiceProvider, isRootScope: Bool) {
		_resolvedServices = HashMap<ServiceCacheKey, ?Any>()
		_rootProvider = provider
		_isRootScope = isRootScope
	}

	private let _resolvedServices: HashMap<ServiceCacheKey, ?Any>

	internal prop resolvedServices: HashMap<ServiceCacheKey, ?Any> {
		get() { _resolvedServices }
	}

	internal prop closed: Bool {
		get() { _closed }
	}

	private let _sync: ReentrantMutex = ReentrantMutex()

	internal prop sync: ReentrantMutex {
		get() { _sync }
	}

	private let _isRootScope: Bool

	public prop isRootScope: Bool {
		get() { _isRootScope }
	}

	private let _rootProvider: ServiceProvider

	internal prop rootProvider: ServiceProvider {
		get() { _rootProvider }
	}

	public override func getService(serviceType: TypeInfo): ?Object {
		if (_closed) {
			ThrowHelper.throwResourceClosedException()
		}

		return rootProvider.getService(ServiceIdentifier.fromServiceType(serviceType), this)
	}

	public override func getKeyedService(serviceType: TypeInfo, serviceKey: ?IHashableEquatableToString<?Any>): ?Object {
		if (_closed) {
			ThrowHelper.throwResourceClosedException()
		}

		return rootProvider.getKeyedService(serviceType, serviceKey, this)
	}

	public override func getRequiredKeyedService(serviceType: TypeInfo, serviceKey: ?IHashableEquatableToString<?Any>): Object {
		if (_closed) {
			ThrowHelper.throwResourceClosedException()
		}

		return rootProvider.getRequiredKeyedService(serviceType, serviceKey, this)
	}

	public prop serviceProvider: IServiceProvider {
		get() { this }
	}

	public func createScope(): IServiceScope {
		rootProvider.createScope()
	}
	
	internal func captureResource(service: ?Any): ?Any {
		if (service.isSome() && refEq(this, (service.getOrThrow() as Object).getOrThrow()) ||
			!(service is Resource)) {
			return service
		}

		var closed = false
		sync.lock()
		if (_closed) {
			closed = true
		} else {
			if (_resources.isNone()) {
				_resources = ArrayList<Any>()
			}

			_resources.getOrThrow().add(service.getOrThrow())
		}
		sync.unlock()

		// Don't run customer code under the lock
		if (closed) {
			let resourceOption = service as Resource
			if (resourceOption.isSome()) {
				resourceOption.getOrThrow().close()
			} else {
				// [Unsupported]
				// sync over async, for the rare case that an object only implements IAsyncDisposable and may end up starving the thread pool.
				// object? localService = service; // copy to avoid closure on other paths
				// Task.Run(() => ((IAsyncDisposable)localService).DisposeAsync().AsTask()).GetAwaiter().GetResult();
			}

			ThrowHelper.throwResourceClosedException()
		}

		return service
	}

	public override func close() {
		let toCloseOption: ?ArrayList<Any> = beginClose()

		if (toCloseOption.isSome()) {
			let toClose = toCloseOption.getOrThrow()

			for (i in (toClose.size - 1)..=0) {
				let resourceOption = toClose[i] as Resource
				if (resourceOption.isSome()) {
					resourceOption.getOrThrow().close()
				} else {
					throw InvalidOperationException(SR.format(SR.AsyncResourceServiceClose, [TypeInfo.of(toClose[i]).name]))
				}
			}
		}
	}

	public func isClosed(): Bool { _closed }

	public func beginClose(): ?ArrayList<Any> {
		sync.lock()
		if (_closed) {
			return None
		}

		// [Unsupported]
		// Track statistics about the scope (number of disposable objects and number of disposed services)
		// DependencyInjectionEventSource.Log.ScopeDisposed(RootProvider.GetHashCode(), ResolvedServices.Count, _disposables?.Count ?? 0);

		// We've transitioned to the disposed state, so future calls to
		// CaptureDisposable will immediately dispose the object.
		// No further changes to _state.Disposables, are allowed.
		_closed = true

		if (isRootScope && !rootProvider.isClosed()) {
			// If this ServiceProviderEngineScope instance is a root scope, disposing this instance will need to dispose the RootProvider too.
			// Otherwise the RootProvider will never get disposed and will leak.
			// Note, if the RootProvider get disposed first, it will automatically dispose all attached ServiceProviderEngineScope objects.
			rootProvider.close()
		}

		// ResolvedServices is never cleared for singletons because there might be a compilation running in background
		// trying to get a cached singleton service. If it doesn't find it
		// it will try to create a new one which will result in an ObjectDisposedException.
		sync.unlock()
		return _resources
	}
}
