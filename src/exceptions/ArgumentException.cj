package dependency_injection.exceptions

import dependency_injection.resources.*

/*
	The exception that is thrown when one of the arguments provided to a method is not valid.
*/
public open class ArgumentException <: Exception {
	var _paramName: ?String = None

	/*
	Creates a new ArgumentException with its message
	string set to the empty string.
	*/
	public init() {
		super(SR.Arg_ArgumentException)
	}

	/*
	Creates a new ArgumentException with its message
	string set to message.
	*/
	public init(message: ?String) {
		super(message ?? SR.Arg_ArgumentException)
	}

	public init(message: ?String, paramName: ?String) {
		super(message ?? SR.Arg_ArgumentException)
		_paramName = paramName
	}

	public open override prop message: String {
		get() {
			var s = super.message
			if (s.size > 0) {
				s = "${s} ${SR.format(SR.Arg_ParamName_Name, [_paramName])}"
			}

			return s
		}
	}

	public open override func getClassName(): String {
		"ArgumentException"
	}
}
