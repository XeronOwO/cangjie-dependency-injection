package dependency_injection.exceptions

import dependency_injection.resources.*

public class NotSupportedException <: Exception {
	public init() {
		super(SR.Arg_NotSupportedException)
	}

	public init(message: ?String) {
		super(message ?? SR.Arg_NotSupportedException)
	}
}
