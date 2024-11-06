package dependency_injection.abstractions

import dependency_injection.component_model.*
import dependency_injection.corelib.*
import std.core.*
import std.reflect.*

/*
	Describes a service with its service type, implementation, and lifetime.
*/
public class ServiceDescriptor <: ToString {
	/*
	Initializes a new instance of ServiceDescriptor with the specified implementationType.

	serviceType: The Type of the service.
	implementationType: The Type implementing the service.
	lifetime: The ServiceLifetime of the service.
	*/
	public init(
		serviceType: TypeInfo,
		implementationType: TypeInfo,
		lifetime: ServiceLifetime
	) {
		this(serviceType, None, implementationType, lifetime)
	}

	/*
	Initializes a new instance of ServiceDescriptor with the specified implementationType.

	serviceType: The Type of the service.
	serviceKey: The ServiceDescriptor.serviceKey of the service.
	implementationType: The Type implementing the service.
	lifetime: The ServiceLifetime of the service.
	*/
	public init(
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		implementationType: TypeInfo,
		lifetime: ServiceLifetime
	) {
		this(serviceType, serviceKey, lifetime)

		_implementationType = implementationType
	}

	/*
	Initializes a new instance of ServiceDescriptor with the specified instance
	ServiceLifetime.Singleton.
	
	serviceType: The Type of the service.
	instance: The instance implementing the service.
	*/
	public init(
		serviceType: TypeInfo,
		instance: Object
	) {
		this(serviceType, None, instance)
	}

	/*
	Initializes a new instance of ServiceDescriptor with the specified instance
	as a ServiceLifetime.Singleton.
	
	serviceType: The Type of the service.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.
	instance: The instance implementing the service.
	*/
	public init(
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		instance: Object
	) {
		this(serviceType, serviceKey, ServiceLifetime.Singleton)

		_implementationInstance = instance
	}

	/*
	Initializes a new instance of ServiceDescriptor with the specified factory.
    
	serviceType: The Type of the service.
	factory: A factory used for creating service instances.
	lifetime: The ServiceLifetime of the service.
	*/
	public init(
		serviceType: TypeInfo,
		factory: (IServiceProvider) -> Object,
		lifetime: ServiceLifetime
	) {
		this(serviceType, None, lifetime)

		_implementationFactory = factory
	}

	public init(
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		factory: (IServiceProvider, ?IHashableEquatableToString<?Any>) -> Object,
		lifetime: ServiceLifetime
	) {
		this(serviceType, serviceKey, lifetime)

		if (serviceKey.isNone()) {
			// If the key is None, use the same factory signature as non-keyed descriptor
			let noneKeyedFactory: (IServiceProvider) -> Any = { sp => factory(sp, None) }
			_implementationFactory = noneKeyedFactory
		} else {
			_implementationFactory = factory
		}
	}

	private init(
		serviceType: TypeInfo,
		serviceKey: ?IHashableEquatableToString<?Any>,
		lifetime: ServiceLifetime
	) {
		_lifetime = lifetime
		_serviceKey = serviceKey
		_serviceType = serviceType
	}

	let _lifetime: ServiceLifetime

	/*
	Gets the ServiceLifetime of the service.
	*/
	public prop lifetime: ServiceLifetime {
		get() { _lifetime }
	}

	let _serviceKey: ?IHashableEquatableToString<?Any>

	/*
	Get the key of the service, if applicable.
	*/
	public prop serviceKey: ?IHashableEquatableToString<?Any> {
		get() { _serviceKey }
	}

	let _serviceType: TypeInfo

	/*
	Gets the Type of the service.
	*/
	public prop serviceType: TypeInfo {
		get() { _serviceType }
	}

	var _implementationType: ?TypeInfo = None

	/*
	Gets the Type that implements the service,
	or returns None if IsKeyedService is true.
	
	If IsKeyedService is true, KeyedImplementationType should be called instead.
	*/
	public prop implementationType: ?TypeInfo {
		get() {
			if (isKeyedService) {
				return None
			}
			return _implementationType
		}
	}

	/*
	Gets the Type that implements the service,
	or throws InvalidOperationException if IsKeyedService is false.

	If IsKeyedService is false, ImplementationType should be called instead.
	*/
	public prop keyedImplementationType: ?TypeInfo {
		get() {
			if (!isKeyedService) {
				throwNonKeyedDescriptor()
			}
			return _implementationType
		}
	}
	
	private var _implementationInstance: ?Object = None

	/*
	Gets the instance that implements the service,
	or returns None if IsKeyedService is true.

	If IsKeyedService is true, KeyedImplementationInstance should be called instead.
	*/
	public prop implementationInstance: ?Object {
		get() {
			if (!isKeyedService) {
				return None
			}
			return _implementationInstance
		}
	}

	/*
	Gets the instance that implements the service,
	or throws InvalidOperationException if IsKeyedService is false.

	If IsKeyedService is false, ImplementationInstance should be called instead.
	*/
	public prop keyedImplementationInstance: ?Object {
		get() {
			if (!isKeyedService) {
				throwNonKeyedDescriptor()
			}
			return _implementationInstance
		}
	}
	
	private var _implementationFactory: ?Any = None

	/*
	Gets the factory used for creating service instance,
	or returns None if IsKeyedService is true.

	If IsKeyedService is true, KeyedImplementationFactory should be called instead.
	*/
	public prop implementationFactory: ?(IServiceProvider) -> Object {
		get() {
			if (isKeyedService) {
				return None
			}
			if (_implementationFactory.isNone()) {
				return None
			} else {
				return _implementationFactory.getOrThrow() as (IServiceProvider) -> Object
			}
		}
	}

	/*
	Gets the factory used for creating Keyed service instances,
	or throws InvalidOperationException if IsKeyedService is false.

	If IsKeyedService is false, ImplementationFactory should be called instead.
	*/
	public prop keyedImplementationFactory: ?(IServiceProvider, ?IHashableEquatableToString<?Any>) -> Object {
		get() {
			if (!isKeyedService) {
				throwNonKeyedDescriptor()
			}
			return _implementationFactory.getOrThrow() as (IServiceProvider, ?IHashableEquatableToString<?Any>) -> Object
		}
	}

	/*
	Indicates whether the service is a keyed service.
	*/
	public prop isKeyedService: Bool {
		get() { _serviceKey.isSome() }
	}

	private func anyToString<T>(obj: T): String {
		if (obj is ToString) {
			return (obj as ToString).toString()
		}

		try {
			return TypeInfo.of(obj).name
		} catch (e: Exception) {
			return "Unknown"
		}
	}

	private func anyToStringOption<T>(obj: ?T): String {
		if (obj.isNone()) {
			return "None"
		}

		return anyToString<T>(obj.getOrThrow())
	}

	public func toString(): String {
		var lifetime: String = "serviceType: ${serviceType} lifetime: ${lifetime} "

		if (isKeyedService) {
			lifetime = "${lifetime}serviceKey: ${anyToStringOption(serviceKey)} ";

			if (keyedImplementationType.isSome()) {
				return "${lifetime}keyedImplementationType: ${keyedImplementationType}"
			}

			if (keyedImplementationFactory.isSome()) {
				return "${lifetime}keyedImplementationFactory: ${anyToStringOption(keyedImplementationFactory)}"
			}

			return "${lifetime}keyedImplementationInstance: ${anyToStringOption(keyedImplementationInstance)}"
		} else {
			if (implementationType.isSome()) {
				return "${lifetime}implementationType: ${implementationType}"
			}

			if (implementationFactory.isSome()) {
				return "${lifetime}implementationFactory: ${anyToStringOption(implementationFactory)}"
			}

			return "${lifetime}implementationInstance: ${anyToStringOption(implementationInstance)}"
		}
	}

	private static func throwNonKeyedDescriptor() {
		throw InvalidOperationException(SR.NonKeyedDescriptorMisuse)
	}
}
