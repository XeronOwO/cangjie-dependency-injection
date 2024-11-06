package dependency_injection.corelib

/*
	The exception that is thrown when the value of an argument is outside the allowable range of values as defined by the invoked method.
*/
public open class ArgumentOutOfRangeException <: ArgumentException {
	private let _actualValue: ?ToString

	/*
	Creates a new ArgumentOutOfRangeException with its message
	string set to a default message explaining an argument was out of range.
	*/
	public init() {
		super(SR.Arg_ArgumentOutOfRangeException)
		_actualValue = None
	}

	public init(paramName: ?String) {
		super(SR.Arg_ArgumentOutOfRangeException, paramName)
		_actualValue = None
	}

	public init(paramName: ?String, message: ?String) {
		super(message ?? SR.Arg_ArgumentOutOfRangeException, paramName)
		_actualValue = None
	}

	public init(paramName: ?String, actualValue: ?ToString, message: ?String) {
		super(message ?? SR.Arg_ArgumentOutOfRangeException, paramName)
		_actualValue = actualValue
	}

	public open override prop message: String {
		get() {
			let s = super.message
			if (_actualValue.isSome()) {
				let valueMessage = SR.format(SR.ArgumentOutOfRange_ActualValue, _actualValue.getOrThrow())
				return s + Environment.newLineConst + valueMessage
			}
			return s
		}
	}

	public open prop actualValue: ?ToString {
		get() { _actualValue }
	}

	public open override func getClassName(): String {
		"ArgumentOutOfRangeException"
	}
}
