package dependency_injection.corelib

/*
	The exception that is thrown when one of the arguments provided to a method is not valid.
*/
public open class ArgumentException <: SystemException {
	private let _paramName: ?String

	/*
	Creates a new ArgumentException with its message
	string set to the empty string.
	*/
	public init() {
		super(SR.Arg_ArgumentException)
		_paramName = None
	}

	/*
	Creates a new ArgumentException with its message
	string set to message.
	*/
	public init(message: ?String) {
		super(message ?? SR.Arg_ArgumentException)
		_paramName = None
	}

	public init(message: ?String, paramName: ?String) {
		super(message ?? SR.Arg_ArgumentException)
		_paramName = paramName
	}

	public open override prop message: String {
		get() {
			var s = super.message
			if (_paramName.isSome()) {
				s += " " + SR.format(SR.Arg_ParamName_Name, _paramName.getOrThrow())
			}

			return s
		}
	}

	public open prop paramName: ?String {
		get() { _paramName }
	}

	public open override func getClassName(): String {
		"ArgumentException"
	}
}
