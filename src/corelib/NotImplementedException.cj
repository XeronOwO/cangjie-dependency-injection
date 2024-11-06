package dependency_injection.corelib

public class NotImplementedException <: Exception {
	public init() {
		super(SR.Arg_NotImplementedException)
	}

	public init(message: ?String) {
		super(message ?? SR.Arg_NotImplementedException)
	}
}
