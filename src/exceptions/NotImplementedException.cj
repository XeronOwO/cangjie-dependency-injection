package dependency_injection.exceptions

import dependency_injection.resources.*

public class NotImplementedException <: Exception {
	public init() {
		super(SR.Arg_NotImplementedException)
	}

	public init(message: ?String) {
		super(message ?? SR.Arg_NotImplementedException)
	}
}
