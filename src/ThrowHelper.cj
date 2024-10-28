package dependency_inject

import dependency_inject.exceptions.*

internal class ThrowHelper {
	/*
	Throws an ArgumentNoneException if argument is none.
	
	argument: The reference type argument to validate as non-null.
	paramName: The name of the parameter with which argument corresponds.
	*/
	public static func throwIfNone(argument: ?Any, paramName!: ?String = None) {
		if (argument.isNone()) {
			throwNone(paramName)
		}
	}

	private static func throwNone(paramName: ?String) {
		throw ArgumentNoneException(paramName)
	}

	public static func throwResourceClosedException() {
		throw ResourceClosedException("IServiceProvider")
	}
}
