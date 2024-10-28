package dependency_inject.exceptions

import dependency_inject.resources.*

public class NotSupportedException <: Exception {
	public init() {
		super(SR.Arg_NotSupportedException)
	}

	public init(message: ?String) {
		super(message ?? SR.Arg_NotSupportedException)
	}
}
