package dependency_inject.resources

import std.convert.*
import std.reflect.*
import std.regex.*

public class SR {
	public static prop Arg_InvalidOperationException: String {
		get() { "Operation is not valid due to the current state of the object." }
	}

	public static prop Arg_ArgumentException: String {
		get() { "Value does not fall within the expected range." }
	}

	public static prop Arg_ParamName_Name: String {
		get() { "(Parameter '{0}')" }
	}

	public static prop Arg_ArgumentOutOfRangeException: String {
		get() { "Specified argument was out of the range of valid values." }
	}

	public static prop ArgumentOutOfRange_ActualValue: String {
		get() { "Actual value was {0}." }
	}

	public static prop ArgumentNone_Generic: String {
		get() { "Value cannot be none." }
	}

	public static prop ResourceClosed_Generic: String {
		get() { "Cannot access a closed object." }
	}

	public static prop Arg_NotImplementedException: String {
		get() { "The method or operation is not implemented." }
	}

	public static prop AggregateException_ctor_DefaultMessage: String {
		get() { "One or more errors occurred." }
	}

	public static prop Arg_NotSupportedException: String {
		get() { "Specified method is not supported." }
	}

	public static prop NonKeyedDescriptorMisuse: String {
		get() { "This service descriptor is not keyed." }
	}

	public static prop ServiceCollectionReadOnly: String {
		get() { "The service collection cannot be modified because it is read-only." }
	}

	public static prop ImplementationTypeCantBeConvertedToServiceType: String {
		get() { "Implementation type '{0}' can't be converted to service type '{1}'" }
	}

	public static prop ConstantCantBeConvertedToServiceType: String {
		get() { "Constant value of type '{0}' can't be converted to service type '{1}'" }
	}

	public static prop DirectScopedResolvedFromRootException: String {
		get() { "Cannot resolve {1} service '{0}' from root provider." }
	}

	public static prop ScopedInSingletonException: String {
		get() { "Cannot consume {2} service '{0}' from {3} '{1}'." }
	}

	public static prop ScopedResolvedFromRootException: String {
		get() { "Cannot resolve '{0}' from root provider because it requires {2} service '{1}'." }
	}

	public static prop AsyncResourceServiceClose: String {
		get() { "'{0}' type only implements AsyncResource. Use CloseAsync to close the container." }
	}

	public static prop ServiceDescriptorNotExist: String {
		get() { "Requested service descriptor doesn't exist." }
	}

	public static prop TypeCannotBeActivated: String {
		get() { "Cannot instantiate implementation type '{0}' for service type '{1}'." }
	}

	public static prop CircularDependencyException: String {
		get() { "{0} = service type with circular dependency" }
	}

	public static prop InvalidServiceDescriptor: String {
		get() { "Invalid service descriptor" }
	}

	public static prop NoConstructorMatched: String {
		get() { "A suitable constructor for type '{0}' could not be located. Ensure the type is concrete and services are registered for all parameters of a public constructor." }
	}

	public static prop InvalidServiceKeyType: String {
		get() { "The type of the key used for lookup doesn't match the type in the constructor parameter with the ServiceKey annotation." }
	}

	public static prop CannotResolveService: String {
		get() { "Unable to resolve service for type '{0}' while attempting to activate '{1}'." }
	}

	public static prop NoServiceRegistered: String {
		get() { "No service for type '{0}' has been registered." }
	}

	public static prop AmbiguousConstructorException: String {
		get() { "Unable to activate type '{0}'. The following constructors are ambiguous:" }
	}

	public static prop UnableToActivateTypeException: String {
		get() { "No constructor for type '{0}' can be instantiated using services from the service container and default values." }
	}

	public static prop NoServiceRegisteredForType: String {
		get() { "No service for type '{0}' has been registered." }
	}

	public static prop KeyedServicesNotSupported: String {
		get() { "This service provider doesn't support keyed services." }
	}

	public static func format(format: String, args: Array<ToString>): String {
		return formatParamterIndex(format, args)
	}

	private static let _parameterIndexRegex = Regex(##"\{(\d+)\}"##)

	private static func formatParamterIndex(format: String, args: Array<ToString>): String {
		let matcher = _parameterIndexRegex.matcher(format)
		let matchesOption = matcher.findAll()
		let stringBuilder = StringBuilder()

		if (matchesOption.isNone()) {
			return format
		}

		let matches = matchesOption.getOrThrow()
		var index = 0
		for (mat in matches) {
			let position = mat.matchPosition(0)
			let paddingIndex = Int64.parse(mat.matchStr(1))

			stringBuilder.append(format[index..position.start])
			stringBuilder.append(args[paddingIndex])

			index = position.end
		}

		stringBuilder.append(format[index..])
		return stringBuilder.toString()
	}
}
