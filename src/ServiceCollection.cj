package dependency_inject

import dependency_inject.exceptions.*
import dependency_inject.resources.*
import std.reflect.*
import std.collection.*

public class ServiceCollection <: IServiceCollection {
	private var _descriptors: ArrayList<ServiceDescriptor> = ArrayList<ServiceDescriptor>()

	private var _isReadOnly: Bool = false

	public prop count: Int64 {
		get() { _descriptors.size }
	}

	public prop isReadOnly: Bool {
		get() { _isReadOnly }
	}
	
	public operator func [](index: Int64): ServiceDescriptor {
		return _descriptors[index]
	}

	public operator func [](index: Int64, value!: ServiceDescriptor): Unit {
		_descriptors[index] = value
	}

	public override func isEmpty(): Bool {
		return _descriptors.isEmpty()
	}

	public func clear(): Unit {
		_descriptors.clear()
	}

	public func getIterator(): Iterator<ServiceDescriptor> {
		return _descriptors.iterator()
	}

	public override func add(descriptor: ServiceDescriptor): Unit {
		checkReadOnly()
		_descriptors.append(descriptor)
	}

	public override func insert(index: Int64, item: ServiceDescriptor): Unit {
		checkReadOnly()
		_descriptors.insert(index, item)
	}

	public override func removeAt(index: Int64): ServiceDescriptor {
		checkReadOnly()
		return _descriptors.remove(index)
	}

	public override func iterator(): Iterator<ServiceDescriptor> {
		return _descriptors.iterator()
	}

	public override prop size: Int64 {
		get() { _descriptors.size }
	}

	/*
	Makes this collection read-only.

	After the collection is marked as read-only, any further attempt to modify it throws an InvalidOperationException.
	*/
	public func makeReadOnly(): Unit {
		_isReadOnly = true
	}

	private func checkReadOnly(): Unit {
		if (_isReadOnly) {
			throwReadOnlyException()
		}
	}

	private static func throwReadOnlyException() {
		throw InvalidOperationException(SR.ServiceCollectionReadOnly)
	}
	
	public func addTransient(
		serviceType: TypeInfo,
		implementationType: TypeInfo
	): IServiceCollection {
		return add2(this, serviceType, implementationType, ServiceLifetime.Transient)
	}

	public func addTransient(
		serviceType: TypeInfo,
		implementationFactory: (IServiceProvider) -> Object
	): IServiceCollection {
		return add2(this, serviceType, implementationFactory, ServiceLifetime.Transient)
	}

	public static func addTransient2<TService, TImplementation>(
		services: IServiceCollection
		): IServiceCollection where TImplementation <: Object & TService {
		return services.addTransient(TypeInfo.of<TService>(), TypeInfo.of<TImplementation>())
	}

	public func addTransient(
		serviceType: TypeInfo
	): IServiceCollection {
		return addTransient(serviceType, serviceType)
	}

	public static func addTransient1<TService>(
		services: IServiceCollection
	): IServiceCollection where TService <: Object {
		return services.addTransient(TypeInfo.of<TService>())
	}

	public static func addTransient1<TService>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection {
		return services.addTransient(TypeInfo.of<TService>(), { sp => (implementationFactory(sp) as Object).getOrThrow() })
	}

	public static func addTransient2<TService, TImplementation>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection where TImplementation <: Object & TService {
		return services.addTransient(TypeInfo.of<TService>(), { sp => (implementationFactory(sp) as Object).getOrThrow() })
	}

	public func addScoped(
		serviceType: TypeInfo,
		implementationType: TypeInfo
	): IServiceCollection {
		return add2(this, serviceType, implementationType, ServiceLifetime.Scoped)
	}

	public func addScoped(
		serviceType: TypeInfo,
		implementationFactory: (IServiceProvider) -> Object
	): IServiceCollection {
		return add2(this, serviceType, implementationFactory, ServiceLifetime.Scoped)
	}

	public static func addScoped2<TService, TImplementation>(
		services: IServiceCollection
	): IServiceCollection where TImplementation <: Object & TService {
		return services.addScoped(TypeInfo.of<TService>(), TypeInfo.of<TImplementation>())
	}

	public func addScoped(
		serviceType: TypeInfo
	): IServiceCollection {
		return addScoped(serviceType, serviceType)
	}

	public static func addScoped1<TService>(
		services: IServiceCollection
	): IServiceCollection where TService <: Object {
		return services.addScoped(TypeInfo.of<TService>())
	}

	public static func addScoped1<TService>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection {
		return services.addScoped(TypeInfo.of<TService>(), { sp => (implementationFactory(sp) as Object).getOrThrow() })
	}

	public static func addScoped2<TService, TImplementation>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection where TImplementation <: Object & TService {
		return services.addScoped(TypeInfo.of<TService>(), { sp => (implementationFactory(sp) as Object).getOrThrow() })
	}

	public func addSingleton(
		serviceType: TypeInfo,
		implementationType: TypeInfo
	): IServiceCollection {
		return add2(this, serviceType, implementationType, ServiceLifetime.Singleton)
	}

	public func addSingleton(
		serviceType: TypeInfo,
		implementationFactory: (IServiceProvider) -> Object
	): IServiceCollection {
		return add2(this, serviceType, implementationFactory, ServiceLifetime.Singleton)
	}

	public static func addSingleton2<TService, TImplementation>(
		services: IServiceCollection
	): IServiceCollection where TImplementation <: Object & TService {
		return services.addSingleton(TypeInfo.of<TService>(), TypeInfo.of<TImplementation>())
	}

	public func addSingleton(
		serviceType: TypeInfo
	): IServiceCollection {
		return addSingleton(serviceType, serviceType)
	}

	public static func addSingleton1<TService>(
		services: IServiceCollection
	): IServiceCollection where TService <: Object {
		return services.addSingleton(TypeInfo.of<TService>())
	}

	public static func addSingleton1<TService>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection {
		return services.addSingleton(TypeInfo.of<TService>(), { sp => (implementationFactory(sp) as Object).getOrThrow() })
	}

	public static func addSingleton2<TService, TImplementation>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection where TImplementation <: Object & TService {
		return services.addSingleton(TypeInfo.of<TService>(), { sp => (implementationFactory(sp) as Object).getOrThrow() })
	}

	public func addSingleton(
		serviceType: TypeInfo,
		implementationInstance: Object
	): IServiceCollection {
		var serviceDescriptor = ServiceDescriptor(serviceType, implementationInstance)
		add(serviceDescriptor)
		return this
	}

	public static func addSingleton1<TService>(
		services: IServiceCollection,
		implementationInstance: TService
	): IServiceCollection {
		return services.addSingleton(TypeInfo.of<TService>(), (implementationInstance as Object).getOrThrow())
	}

	private static func add2(
		collection: IServiceCollection,
		serviceType: TypeInfo,
		implementationType: TypeInfo,
		lifetime: ServiceLifetime
	): IServiceCollection {
		let descriptor = ServiceDescriptor(serviceType, implementationType, lifetime)
		collection.add(descriptor)
		return collection
	}

	private static func add2(
		collection: IServiceCollection,
		serviceType: TypeInfo,
		implementationFactory: (IServiceProvider) -> Object,
		lifetime: ServiceLifetime
	): IServiceCollection {
		let descriptor = ServiceDescriptor(serviceType, implementationFactory, lifetime)
		collection.add(descriptor)
		return collection
	}

	public func addKeyedTransient(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationType: TypeInfo
	): IServiceCollection {
		return addKeyed(this, serviceType, serviceKey, implementationType, ServiceLifetime.Transient)
	}

	public func addKeyedTransient(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> Object
	): IServiceCollection {
		return addKeyed(this, serviceType, serviceKey, implementationFactory, ServiceLifetime.Transient)
	}

	public static func addKeyedTransient2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection where TImplementation <: Object & TService {
		return services.addKeyedTransient(TypeInfo.of<TService>(), serviceKey, TypeInfo.of<TImplementation>())
	}

	public func addKeyedTransient(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection {
		return addKeyedTransient(serviceType, serviceKey, serviceType)
	}

	public static func addKeyedTransient1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection where TService <: Object {
		return services.addKeyedTransient(TypeInfo.of<TService>(), serviceKey)
	}

	public static func addKeyedTransient1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection {
		return services.addKeyedTransient(TypeInfo.of<TService>(), serviceKey, { sp, key => (implementationFactory(sp, key) as Object).getOrThrow() })
	}

	public static func addKeyedTransient2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection where TImplementation <: Object & TService {
		return services.addKeyedTransient(TypeInfo.of<TService>(), serviceKey, { sp, key => (implementationFactory(sp, key) as Object).getOrThrow() })
	}

	public func addKeyedScoped(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationType: TypeInfo
	): IServiceCollection {
		return addKeyed(this, serviceType, serviceKey, implementationType, ServiceLifetime.Scoped)
	}

	public func addKeyedScoped(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> Object
	): IServiceCollection {
		return addKeyed(this, serviceType, serviceKey, implementationFactory, ServiceLifetime.Scoped)
	}

	public static func addKeyedScoped2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection where TImplementation <: Object & TService {
		return services.addKeyedScoped(TypeInfo.of<TService>(), serviceKey, TypeInfo.of<TImplementation>())
	}

	public func addKeyedScoped(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection {
		return addKeyedScoped(serviceType, serviceKey, serviceType)
	}

	public static func addKeyedScoped1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection {
		return services.addKeyedScoped(TypeInfo.of<TService>(), serviceKey)
	}

	public static func addKeyedScoped1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection {
		return services.addKeyedScoped(TypeInfo.of<TService>(), serviceKey, { sp, key => (implementationFactory(sp, key) as Object).getOrThrow() })
	}

	public static func addKeyedScoped2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection where TImplementation <: Object & TService {
		return services.addKeyedScoped(TypeInfo.of<TService>(), serviceKey, { sp, key => (implementationFactory(sp, key) as Object).getOrThrow() })
	}

	public func addKeyedSingleton(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationType: TypeInfo
	): IServiceCollection {
		return addKeyed(this, serviceType, serviceKey, implementationType, ServiceLifetime.Singleton)
	}

	public func addKeyedSingleton(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> Object
	): IServiceCollection {
		return addKeyed(this, serviceType, serviceKey, implementationFactory, ServiceLifetime.Singleton)
	}

	public static func addKeyedSingleton2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection where TImplementation <: Object & TService {
		return services.addKeyedSingleton(TypeInfo.of<TService>(), serviceKey, TypeInfo.of<TImplementation>())
	}

	public func addKeyedSingleton(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection {
		return addKeyedSingleton(serviceType, serviceKey, serviceType)
	}

	public static func addKeyedSingleton1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection {
		return services.addKeyedSingleton(TypeInfo.of<TService>(), serviceKey, TypeInfo.of<TService>())
	}

	public static func addKeyedSingleton1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection {
		return services.addKeyedSingleton(TypeInfo.of<TService>(), serviceKey, { sp, key => (implementationFactory(sp, key) as Object).getOrThrow() })
	}

	public static func addKeyedSingleton2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection where TImplementation <: Object & TService {
		return services.addKeyedSingleton(TypeInfo.of<TService>(), serviceKey, { sp, key => (implementationFactory(sp, key) as Object).getOrThrow() })
	}

	public func addKeyedSingleton(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationInstance: Object
	): IServiceCollection {
		let descriptor = ServiceDescriptor(serviceType, serviceKey, implementationInstance)
		add(descriptor)
		return this
	}

	public static func addKeyedSingleton1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationInstance: TService
	): IServiceCollection {
		return services.addKeyedSingleton(TypeInfo.of<TService>(), serviceKey, (implementationInstance as Object).getOrThrow())
	}

	private static func addKeyed(
		collection: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationType: TypeInfo,
		lifetime: ServiceLifetime
	): IServiceCollection {
		let descriptor = ServiceDescriptor(serviceType, serviceKey, implementationType, lifetime)
		collection.add(descriptor)
		return collection
	}

	private static func addKeyed(
		collection: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> Object,
		lifetime: ServiceLifetime
	): IServiceCollection {
		let descriptor = ServiceDescriptor(serviceType, serviceKey, { sp, key => implementationFactory(sp, key) }, lifetime)
		collection.add(descriptor)
		return collection
	}
}
