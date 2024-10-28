package dependency_inject

import std.reflect.*

/*
	Specifies the contract for a collection of service descriptors.
*/
public interface IServiceCollection <: IList<ServiceDescriptor> {
	/*
	Adds a transient service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	services: The IServiceCollection to add the service to.
	serviceType: The type of the service to register.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addTransient(
		serviceType: TypeInfo,
		implementationType: TypeInfo
	): IServiceCollection

	/*
	Adds a transient service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addTransient(
		serviceType: TypeInfo,
		implementationFactory: (IServiceProvider) -> Object
	): IServiceCollection

	/*
	Adds a transient service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addTransient2<TService, TImplementation>(
		services: IServiceCollection
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a transient service of the type specified in serviceType to the
	specified IServiceCollection.

	serviceType: The type of the service to register.

	returns: A reference to this instance after the operation has completed.
	*/
	func addTransient(
		serviceType: TypeInfo
	): IServiceCollection

	/*
	Adds a transient service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addTransient1<TService>(
		services: IServiceCollection
	): IServiceCollection where TService <: Object

	/*
	Adds a transient service of the type specified in TService with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addTransient1<TService>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection

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
	static func addTransient2<TService, TImplementation>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a scoped service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addScoped(
		serviceType: TypeInfo,
		implementationType: TypeInfo
	): IServiceCollection

	/*
	Adds a scoped service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addScoped(
		serviceType: TypeInfo,
		implementationFactory: (IServiceProvider) -> Object
	): IServiceCollection

	/*
	Adds a scoped service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addScoped2<TService, TImplementation>(
		services: IServiceCollection
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a scoped service of the type specified in serviceType to the
	specified IServiceCollection.

	serviceType: The type of the service to register.

	returns: A reference to this instance after the operation has completed.
	*/
	func addScoped(
		serviceType: TypeInfo
	): IServiceCollection

	/*
	Adds a scoped service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addScoped1<TService>(
		services: IServiceCollection
	): IServiceCollection where TService <: Object

	/*
	Adds a scoped service of the type specified in TService with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addScoped1<TService>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection

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
	static func addScoped2<TService, TImplementation>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a singleton service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addSingleton(
		serviceType: TypeInfo,
		implementationType: TypeInfo
	): IServiceCollection

	/*
	Adds a singleton service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addSingleton(
		serviceType: TypeInfo,
		implementationFactory: (IServiceProvider) -> Object
	): IServiceCollection

	/*
	Adds a singleton service of the type specified in TService with an
	implementation of the type specified in TImplementation to the
	specified IServiceCollection.

	TService: The type of the service to add.
	TImplementation: The type of the implementation to use.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addSingleton2<TService, TImplementation>(
		services: IServiceCollection
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a singleton service of the type specified in serviceType to the
	specified IServiceCollection.

	serviceType: The type of the service to register.

	returns: A reference to this instance after the operation has completed.
	*/
	func addSingleton(
		serviceType: TypeInfo
	): IServiceCollection

	/*
	Adds a singleton service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addSingleton1<TService>(
		services: IServiceCollection
	): IServiceCollection where TService <: Object

	/*
	Adds a singleton service of the type specified in TService with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addSingleton1<TService>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection

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
	static func addSingleton2<TService, TImplementation>(
		services: IServiceCollection,
		implementationFactory: (IServiceProvider) -> TService
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a singleton service of the type specified in serviceType with an
	instance specified in implementationInstance to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	implementationInstance: The instance of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addSingleton(
		serviceType: TypeInfo,
		implementationInstance: Object
	): IServiceCollection

	/*
	Adds a singleton service of the type specified in TService with an
	instance specified in implementationInstance to the
	specified IServiceCollection.

	TService: The type of the service to register.

	services: The IServiceCollection to add the service to.
	implementationInstance: The instance of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addSingleton1<TService>(
		services: IServiceCollection,
		implementationInstance: TService
	): IServiceCollection

	/*
	Adds a transient service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addKeyedTransient(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationType: TypeInfo
	): IServiceCollection

	/*
	Adds a transient service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addKeyedTransient(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> Object
	): IServiceCollection

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
	static func addKeyedTransient2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a transient service of the type specified in TService to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addKeyedTransient(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection

	/*
	Adds a transient service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addKeyedTransient1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection where TService <: Object

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
	static func addKeyedTransient1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection

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
	static func addKeyedTransient2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a scoped service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addKeyedScoped(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationType: TypeInfo
	): IServiceCollection

	/*
	Adds a scoped service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addKeyedScoped(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> Object
	): IServiceCollection

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
	static func addKeyedScoped2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a scoped service of the type specified in TService to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addKeyedScoped(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection

	/*
	Adds a scoped service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addKeyedScoped1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection where TService <: Object

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
	static func addKeyedScoped1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection

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
	static func addKeyedScoped2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a singleton service of the type specified in serviceType with an
	implementation of the type specified in implementationType to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationType: The implementation type of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addKeyedSingleton(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationType: TypeInfo
	): IServiceCollection

	/*
	Adds a singleton service of the type specified in serviceType with a
	factory specified in implementationFactory to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationFactory: The factory that creates the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addKeyedSingleton(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> Object
	): IServiceCollection

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
	static func addKeyedSingleton2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a singleton service of the type specified in TService to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addKeyedSingleton(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection

	/*
	Adds a singleton service of the type specified in TService to the
	specified IServiceCollection.

	TService: The type of the service to add.

	services: The IServiceCollection to add the service to.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	static func addKeyedSingleton1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>
	): IServiceCollection where TService <: Object

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
	static func addKeyedSingleton1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection

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
	static func addKeyedSingleton2<TService, TImplementation>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationFactory: (IServiceProvider, ?HashableEquatable<?Any>) -> TService
	): IServiceCollection where TImplementation <: Object & TService

	/*
	Adds a singleton service of the type specified in serviceType with an
	instance specified in implementationInstance to the
	specified IServiceCollection.

	serviceType: The type of the service to register.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	implementationInstance: The instance of the service.

	returns: A reference to this instance after the operation has completed.
	*/
	func addKeyedSingleton(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		implementationInstance: Object
	): IServiceCollection

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
	static func addKeyedSingleton1<TService>(
		services: IServiceCollection,
		serviceKey: ?HashableEquatable<?Any>,
		implementationInstance: TService
	): IServiceCollection
}
