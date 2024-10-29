package dependency_injection.exceptions

import dependency_injection.resources.*
import dependency_injection.runtime.*

public open class ArgumentOutOfRangeException <: ArgumentException {
	private let _actualValue: ?ToString
	
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

	public override prop message: String {
		get() {
			var s = super.message
			if (_actualValue.isSome()) {
				let valueMessage = SR.format(SR.ArgumentOutOfRange_ActualValue, [_actualValue])
				return s + Environment.newLineConst + valueMessage
			}

			return s
		}
	}

	public override func getClassName(): String {
		"ObjectDisposedException"
	}

	public open prop actualValue: ?ToString {
		get() { _actualValue }
	}
}
