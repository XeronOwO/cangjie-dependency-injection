package dependency_injection

import dependency_injection.resources.*
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
		this(serviceType, Option<HashableEquatable<?Any>>.None, implementationType, lifetime)
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
		serviceKey: ?HashableEquatable<?Any>,
		implementationType: TypeInfo,
		lifetime: ServiceLifetime
	) {
		this(serviceType, serviceKey, lifetime)
		ThrowHelper.throwIfNone(serviceType)
		ThrowHelper.throwIfNone(implementationType)

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
		serviceKey: ?HashableEquatable<?Any>,
		instance: Object
	) {
		this(serviceType, serviceKey, ServiceLifetime.Singleton)
		ThrowHelper.throwIfNone(serviceType)
		ThrowHelper.throwIfNone(instance)

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
		ThrowHelper.throwIfNone(serviceType)

		_implementationFactory = factory
	}

	public init(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
		factory: (IServiceProvider, ?HashableEquatable<?Any>) -> Object,
		lifetime: ServiceLifetime
	) {
		this(serviceType, serviceKey, lifetime)
		ThrowHelper.throwIfNone(serviceType)

		if (serviceKey.isNone()) {
			// If the key is null, use the same factory signature as non-keyed descriptor
			let nullKeyedFactory: (IServiceProvider) -> Object = { sp => factory(sp, None) }
			_implementationFactory = nullKeyedFactory
		} else {
			_implementationFactory = factory
		}
	}

	private init(
		serviceType: TypeInfo,
		serviceKey: ?HashableEquatable<?Any>,
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

	let _serviceKey: ?HashableEquatable<?Any>

	/*
	Get the key of the service, if applicable.
	*/
	public prop serviceKey: ?HashableEquatable<?Any> {
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
	or returns null if IsKeyedService is true.

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
	public prop keyedImplementationFactory: ?(IServiceProvider, ?Any) -> Object {
		get() {
			if (!isKeyedService) {
				throwNonKeyedDescriptor()
			}
			return _implementationFactory.getOrThrow() as (IServiceProvider, ?Any) -> Object
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
		throw InvocationTargetException(SR.NonKeyedDescriptorMisuse)
	}
}
