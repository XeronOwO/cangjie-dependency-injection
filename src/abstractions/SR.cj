package dependency_injection.abstractions

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

	public static prop NonKeyedDescriptorMisuse: String {
		get() { "This service descriptor is not keyed." }
	}

	public static prop ServiceCollectionReadOnly: String {
		get() { "The service collection cannot be modified because it is read-only." }
	}

	public static prop ImplementationMustBeSubtypeOfService: String {
		get() { "The implementation type must be a subtype of the service type." }
	}

	public static prop NoServiceRegistered: String {
		get() { "No service for type '{0}' has been registered." }
	}
}
