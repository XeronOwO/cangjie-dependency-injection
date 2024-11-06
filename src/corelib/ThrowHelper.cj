package dependency_injection.corelib

internal class ThrowHelper {
	internal static func throwArgumentOutOfRangeException(argument: ExceptionArgument, resource: ExceptionResource) {
		throw getArgumentOutOfRangeException(argument, resource)
	}

	internal static func throwInvalidOperationException_InvalidOperation_EnumFailedVersion() {
		throw InvalidOperationException(SR.InvalidOperation_EnumFailedVersion)
	}

	internal static func throwArgumentOutOfRange_IndexMustBeLessException() {
		throw getArgumentOutOfRangeException(ExceptionArgument.index, ExceptionResource.ArgumentOutOfRange_IndexMustBeLess)
	}

	private static func getArgumentOutOfRangeException(argument: ExceptionArgument, resource: ExceptionResource) {
		return ArgumentOutOfRangeException(getArgumentName(argument), getResourceString(resource))
	}

	private static func getResourceString(resource: ExceptionResource): String {
		match (resource) {
			case ExceptionResource.ArgumentOutOfRange_IndexMustBeLess => SR.ArgumentOutOfRange_IndexMustBeLess
			case ExceptionResource.ArgumentOutOfRange_ListInsert => SR.ArgumentOutOfRange_ListInsert
			case ExceptionResource.ArgumentOutOfRange_NeedNonNegNum => SR.ArgumentOutOfRange_ActualValue
			case ExceptionResource.ArgumentOutOfRange_SmallCapacity => SR.ArgumentOutOfRange_SmallCapacity
		}
	}

	private static func getArgumentName(argument: ExceptionArgument): String {
		match (argument) {
			case ExceptionArgument.capacity => "capacity"
			case ExceptionArgument.index => "index"
			case ExceptionArgument.value => "value"
		}
	}
}

internal enum ExceptionArgument {
	| capacity
	| index
	| value
}

internal enum ExceptionResource {
	| ArgumentOutOfRange_IndexMustBeLess
	| ArgumentOutOfRange_ListInsert
	| ArgumentOutOfRange_NeedNonNegNum
	| ArgumentOutOfRange_SmallCapacity
}
