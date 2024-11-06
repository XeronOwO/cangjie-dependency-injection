package dependency_injection.corelib

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

	public static prop Arg_SystemException: String {
		get() { "System error." }
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

	public static prop ArgumentOutOfRange_SmallCapacity: String {
		get() { "Capacity was less than the current size." }
	}

	public static prop ArgumentOutOfRange_IndexMustBeLess: String {
		get() { "Index was out of range. Must be non-negative and less than the size of the collection." }
	}

	public static prop ArgumentOutOfRange_ListInsert: String {
		get() { "Index must be within the bounds of the List." }
	}

	public static prop InvalidOperation_EnumFailedVersion: String {
		get() { "Collection was modified; enumeration operation may not execute." }
	}

	public static prop Arg_InvalidOperationException: String {
		get() { "Operation is not valid due to the current state of the object." }
	}

	public static prop Arg_NotImplementedException: String {
		get() { "The method or operation is not implemented." }
	}

	public static prop AggregateException_ctor_DefaultMessage: String {
		get() { "One or more errors occurred." }
	}

	public static prop ResourceClosed_Generic: String {
		get() { "Cannot access a closed resource." }
	}
}
