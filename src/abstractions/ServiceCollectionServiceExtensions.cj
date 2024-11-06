package dependency_injection.abstractions

import dependency_injection.component_model.*
import dependency_injection.corelib.*
import std.reflect.*

/*
	Extension methods for adding services to an IServiceCollection.
*/
public class ServiceCollectionServiceExtensions {
	/**************************
	*                         *
	*        Non-Keyed        *
	*                         *
	**************************/
	
	/*
	Adds a transient service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addTransient(
		services: IServiceCollection,
		serviceType: TypeInfo,
		implementationType: TypeInfo
	): IServiceCollection {
		return add(services, serviceType, implementationType, ServiceLifetime.Transient)
	}

	/*
	Adds a transient service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addTransient(
		services: IServiceCollection,
		serviceType: TypeInfo,
		implementationFactory: (IServiceProvider) -> Object
	): IServiceCollection {
		return add(services, serviceType, implementationFactory, ServiceLifetime.Transient)
	}

	/*
	Adds a transient service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addTransient2<TService, TImplementation>(
		services: IServiceCollection
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addTransient(services, TypeInfo.of<TService>(), TypeInfo.of<TImplementation>())
	}

	/*
	Adds a transient service of the type specified in serviceType to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addTransient(
		services: IServiceCollection,
		serviceType: TypeInfo
	): IServiceCollection {
		return addTransient(services, serviceType, serviceType)
	}

	/*
	Adds a transient service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addTransient1<TService>(
		services: IServiceCollection
	): IServiceCollection where TService <: Object {
		return addTransient(services, TypeInfo.of<TService>())
	}

	/*
	Adds a transient service of the type specified in TService with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addTransient1<TService>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection where TService <: Object {
		return addTransient(services, TypeInfo.of<TService>(), implementationFactory)
	}

	/*
	Adds a transient service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addTransient2<TService, TImplementation>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TImplementation
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addTransient(services, TypeInfo.of<TService>(), implementationFactory)
	}

	/*
	Adds a scoped service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addScoped(
		services: IServiceCollection,
		serviceType: TypeInfo,
		implementationType: TypeInfo
	): IServiceCollection {
		return add(services, serviceType, implementationType, ServiceLifetime.Scoped)
	}

	/*
	Adds a scoped service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addScoped(
		services: IServiceCollection,
		serviceType: TypeInfo,
		implementationFactory: (IServiceProvider) -> Object
	): IServiceCollection {
		return add(services, serviceType, implementationFactory, ServiceLifetime.Scoped)
	}

	/*
	Adds a scoped service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addScoped2<TService, TImplementation>(
		services: IServiceCollection
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addScoped(services, TypeInfo.of<TService>(), TypeInfo.of<TImplementation>())
	}

	/*
	Adds a scoped service of the type specified in serviceType to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addScoped(
		services: IServiceCollection,
		serviceType: TypeInfo
	): IServiceCollection {
		return addScoped(services, serviceType, serviceType)
	}

	/*
	Adds a scoped service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addScoped1<TService>(
		services: IServiceCollection
	): IServiceCollection where TService <: Object {
		return addScoped(services, TypeInfo.of<TService>())
	}

	/*
	Adds a scoped service of the type specified in TService with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addScoped1<TService>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection where TService <: Object {
		return addScoped(services, TypeInfo.of<TService>(), implementationFactory)
	}

	/*
	Adds a scoped service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addScoped2<TService, TImplementation>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TImplementation
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addScoped(services, TypeInfo.of<TService>(), implementationFactory)
	}

	/*
	Adds a singleton service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addSingleton(
		services: IServiceCollection,
		serviceType: TypeInfo,
		implementationType: TypeInfo
	): IServiceCollection {
		return add(services, serviceType, implementationType, ServiceLifetime.Singleton)
	}

	/*
	Adds a singleton service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addSingleton(
		services: IServiceCollection,
		serviceType: TypeInfo,
		implementationFactory: (IServiceProvider) -> Object
	): IServiceCollection {
		return add(services, serviceType, implementationFactory, ServiceLifetime.Singleton)
	}

	/*
	Adds a singleton service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addSingleton2<TService, TImplementation>(
		services: IServiceCollection
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addSingleton(services, TypeInfo.of<TService>(), TypeInfo.of<TImplementation>())
	}

	/*
	Adds a singleton service of the type specified in serviceType to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addSingleton(
		services: IServiceCollection,
		serviceType: TypeInfo
	): IServiceCollection {
		return addSingleton(services, serviceType, serviceType)
	}

	/*
	Adds a singleton service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addSingleton1<TService>(
		services: IServiceCollection
	): IServiceCollection where TService <: Object {
		return addSingleton(services, TypeInfo.of<TService>())
	}

	/*
	Adds a singleton service of the type specified in TService with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addSingleton1<TService>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection where TService <: Object {
		return addSingleton(services, TypeInfo.of<TService>(), implementationFactory)
	}

	/*
	Adds a singleton service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addSingleton2<TService, TImplementation>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TImplementation
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addSingleton(services, TypeInfo.of<TService>(), implementationFactory)
	}

	/*
	Adds a singleton service of the type specified in serviceType with an
	instance specified in implementationInstance to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	implementationInstance: The instance of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addSingleton(
		services: IServiceCollection,
		serviceType: TypeInfo,
		implementationInstance: Object
	): IServiceCollection {
		let serviceDescriptor = ServiceDescriptor(serviceType, implementationInstance)
		services.add(serviceDescriptor)
		return services
	}

	/*
	Adds a singleton service of the type specified in TService with an
	instance specified in implementationInstance to the
	specified IServiceCollection.

	TService: The type of the service to register.

	services: The IServiceCollection to add the service to.
	implementationInstance: The instance of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addSingleton1<TService>(
		services: IServiceCollection,
		implementationInstance: TService
	): IServiceCollection where TService <: Object {
		return addSingleton(services, TypeInfo.of<TService>(), implementationInstance)
	}
	
	private static func add(
		collection: IServiceCollection,
		serviceType: TypeInfo,
		implementationType: TypeInfo,
		lifeTime: ServiceLifetime
	): IServiceCollection {
		let descriptor = ServiceDescriptor(serviceType, implementationType, lifeTime)
		collection.add(descriptor)
		return collection
	}

	private static func add(
		collection: IServiceCollection,
		serviceType: TypeInfo,
		implementationFactory: (IServiceProvider) -> Object,
		lifeTime: ServiceLifetime
	): IServiceCollection {
		let descriptor = ServiceDescriptor(serviceType, implementationFactory, lifeTime)
		collection.add(descriptor)
		return collection
	}



	/**********************
	*                     *
	*        Keyed        *
	*                     *
	**********************/

	/*
	Adds a transient service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedTransient(
		services: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationType: TypeInfo
	): IServiceCollection {
		return addKeyed(services, serviceType, serviceKey, implementationType, ServiceLifetime.Transient)
	}

	/*
	Adds a transient service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedTransient(
		services: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationFactory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> Object
	): IServiceCollection {
		return addKeyed(services, serviceType, serviceKey, implementationFactory, ServiceLifetime.Transient)
	}

	/*
	Adds a transient service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedTransient2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addKeyedTransient(services, TypeInfo.of<TService>(), serviceKey, TypeInfo.of<TImplementation>())
	}

	/*
	Adds a transient service of the type specified in TService to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedTransient(
		services: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>
	): IServiceCollection {
		return addKeyedTransient(services, serviceType, serviceKey, serviceType)
	}

	/*
	Adds a transient service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedTransient1<TService>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>
	): IServiceCollection where TService <: Object {
		return addKeyedTransient(services, TypeInfo.of<TService>(), serviceKey)
	}

	/*
	Adds a transient service of the type specified in TService with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedTransient1<TService>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationFactory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> TService
	): IServiceCollection where TService <: Object {
		return addKeyedTransient(services, TypeInfo.of<TService>(), serviceKey, implementationFactory)
	}

	/*
	Adds a transient service of the type specified in TService with an
	implementation of the type specified in TImplementation using the
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedTransient2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationFactory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> TImplementation
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addKeyedTransient(services, TypeInfo.of<TService>(), serviceKey, implementationFactory)
	}

	/*
	Adds a scoped service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedScoped(
		services: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationType: TypeInfo
	): IServiceCollection {
		return addKeyed(services, serviceType, serviceKey, implementationType, ServiceLifetime.Scoped)
	}

	/*
	Adds a scoped service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedScoped(
		services: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationFactory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> Object
	): IServiceCollection {
		return addKeyed(services, serviceType, serviceKey, implementationFactory, ServiceLifetime.Scoped)
	}

	/*
	Adds a scoped service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedScoped2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addKeyedScoped(services, TypeInfo.of<TService>(), serviceKey, TypeInfo.of<TImplementation>())
	}

	/*
	Adds a scoped service of the type specified in TService to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedScoped(
		services: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>
	): IServiceCollection {
		return addKeyedScoped(services, serviceType, serviceKey, serviceType)
	}

	/*
	Adds a scoped service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedScoped1<TService>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>
	): IServiceCollection where TService <: Object {
		return addKeyedScoped(services, TypeInfo.of<TService>(), serviceKey)
	}

	/*
	Adds a scoped service of the type specified in TService with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedScoped1<TService>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationFactory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> TService
	): IServiceCollection where TService <: Object {
		return addKeyedScoped(services, TypeInfo.of<TService>(), serviceKey, implementationFactory)
	}

	/*
	Adds a scoped service of the type specified in TService with an
	implementation of the type specified in TImplementation using the
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedScoped2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationFactory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> TImplementation
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addKeyedScoped(services, TypeInfo.of<TService>(), serviceKey, implementationFactory)
	}

	/*
	Adds a singleton service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedSingleton(
		services: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationType: TypeInfo
	): IServiceCollection {
		return addKeyed(services, serviceType, serviceKey, implementationType, ServiceLifetime.Singleton)
	}

	/*
	Adds a singleton service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedSingleton(
		services: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationFactory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> Object
	): IServiceCollection {
		return addKeyed(services, serviceType, serviceKey, implementationFactory, ServiceLifetime.Singleton)
	}

	/*
	Adds a singleton service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedSingleton2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addKeyedSingleton(services, TypeInfo.of<TService>(), serviceKey, TypeInfo.of<TImplementation>())
	}

	/*
	Adds a singleton service of the type specified in TService to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedSingleton(
		services: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>
	): IServiceCollection {
		return addKeyedSingleton(services, serviceType, serviceKey, serviceType)
	}

	/*
	Adds a singleton service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedSingleton1<TService>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>
	): IServiceCollection where TService <: Object {
		return addKeyedSingleton(services, TypeInfo.of<TService>(), serviceKey, TypeInfo.of<TService>())
	}

	/*
	Adds a singleton service of the type specified in TService with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedSingleton1<TService>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationFactory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> TService
	): IServiceCollection where TService <: Object {
		return addKeyedSingleton(services, TypeInfo.of<TService>(), serviceKey, implementationFactory)
	}

	/*
	Adds a singleton service of the type specified in TService with an
	implementation of the type specified in TImplementation using the
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedSingleton2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationFactory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> TImplementation
	): IServiceCollection
	where TService <: Object, TImplementation <: Object {
		ensureSubtype<TService, TImplementation>()
		return addKeyedSingleton(services, TypeInfo.of<TService>(), serviceKey, implementationFactory)
	}

	/*
	Adds a singleton service of the type specified in serviceType with an
	instance specified in implementationInstance to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationInstance: The instance of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedSingleton(
		services: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationInstance: Object
	): IServiceCollection {
		let serviceDescriptor = ServiceDescriptor(serviceType, serviceKey, implementationInstance)
		services.add(serviceDescriptor)
		return services
	}

	/*
	Adds a singleton service of the type specified in TService with an
	instance specified in implementationInstance to the
	specified IServiceCollection.

	TService: The type of the service to register.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationInstance: The instance of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	public static func addKeyedSingleton1<TService>(
		services: IServiceCollection,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationInstance: TService
	): IServiceCollection where TService <: Object {
		return addKeyedSingleton(services, TypeInfo.of<TService>(), serviceKey, implementationInstance)
	}

	private static func addKeyed(
		collection: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationType: TypeInfo,
		lifeTime: ServiceLifetime
	): IServiceCollection {
		let descriptor = ServiceDescriptor(serviceType, serviceKey, implementationType, lifeTime)
		collection.add(descriptor)
		return collection
	}

	private static func addKeyed(
		collection: IServiceCollection,
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationFactory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> Object,
		lifeTime: ServiceLifetime
	): IServiceCollection {
		let descriptor = ServiceDescriptor(serviceType, serviceKey, implementationFactory, lifeTime)
		collection.add(descriptor)
		return collection
	}



	/***********************
	*                      *
	*        Common        *
	*                      *
	***********************/

	private static func ensureSubtype<TService, TImplementation>() {
		if (!TypeInfo.of<TImplementation>().isSubtypeOf(TypeInfo.of<TService>())) {
			throw ArgumentException(SR.ImplementationMustBeSubtypeOfService)
		}
	}
}
