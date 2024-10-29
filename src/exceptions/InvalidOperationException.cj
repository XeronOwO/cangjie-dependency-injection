package dependency_injection.exceptions

import dependency_injection.resources.*

public open class InvalidOperationException <: Exception {
	public init() {
		super(SR.Arg_InvalidOperationException)
	}

	public init(message: ?String) {
		super(message ?? SR.Arg_InvalidOperationException)
	}

	public open override func getClassName(): String {
		"InvalidOperationException"
	}
}
