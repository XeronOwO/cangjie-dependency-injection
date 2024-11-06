package dependency_injection.corelib

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
