package dependency_injection

import std.convert.*
import std.regex.*

internal class SR {
	public static func format(format: String, args: Array<ToString>): String {
		return formatParamterIndex(format, args)
	}

	private static let _parameterIndexRegex = Regex(##"\{(\d+)\}"##)

	private static func formatParamterIndex(format: String, args: Array<ToString>): String {
		// Thanks to 祥子 for the code reference

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

	public static prop ConstantCantBeConvertedToServiceType: String {
		get() { "Constant value of type '{0}' can't be converted to service type '{1}'" }
	}

	public static prop ImplementationTypeCantBeConvertedToServiceType: String {
		get() { "Implementation type '{0}' can't be converted to service type '{1}'" }
	}

	public static prop DirectScopedResolvedFromRootException: String {
		get() { "Cannot resolve {1} service '{0}' from root provider." }
	}

	public static prop ScopedResolvedFromRootException: String {
		get() { "Cannot resolve '{0}' from root provider because it requires {2} service '{1}'." }
	}

	public static prop ScopedInSingletonException: String {
		get() { "Cannot consume {2} service '{0}' from {3} '{1}'." }
	}

	public static prop CircularDependencyException: String {
		get() { "A circular dependency was detected for the service of type '{0}'." }
	}

	public static prop TypeCannotBeActivated: String {
		get() { "Cannot instantiate implementation type '{0}' for service type '{1}'." }
	}

	public static prop InvalidServiceDescriptor: String {
		get() { "Invalid service descriptor" }
	}

	public static prop NoConstructorMatch: String {
		get() { "A suitable constructor for type '{0}' could not be located. Ensure the type is concrete and services are registered for all parameters of a public constructor." }
	}

	public static prop AmbiguousConstructorException: String {
		get() { "Unable to activate type '{0}'. The following constructors are ambiguous:" }
	}

	public static prop UnableToActivateTypeException: String {
		get() { "No constructor for type '{0}' can be instantiated using services from the service container and default values." }
	}

	public static prop InvalidServiceKeyType: String {
		get() { "The type of the key used for lookup doesn't match the type in the constructor parameter with the ServiceKey attribute." }
	}

	public static prop CannotResolveService: String {
		get() { "Unable to resolve service for type '{0}' while attempting to activate '{1}'." }
	}

	public static prop ServiceDescriptorNotExist: String {
		get() { "Requested service descriptor doesn't exist." }
	}

	public static prop NoServiceRegistered: String {
		get() { "No service for type '{0}' has been registered." }
	}

	public static prop AsyncResourceServiceClose: String {
		get() { "'{0}' type only implements IAsyncDisposable. Use DisposeAsync to dispose the container." }
	}
}
