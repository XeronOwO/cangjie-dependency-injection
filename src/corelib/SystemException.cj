package dependency_injection.corelib

public open class SystemException <: Exception {
	public init() {
		super(SR.Arg_SystemException)
	}

	public init(message: ?String) {
		super(message ?? SR.Arg_SystemException)
	}

	public open override func getClassName(): String {
		"SystemException"
	}
}
