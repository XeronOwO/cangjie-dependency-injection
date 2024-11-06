package dependency_injection

import dependency_injection.corelib.*

internal class ThrowHelper {
	public static func throwResourceClosedException() {
		throw ResourceClosedException("IServiceProvider")
	}
}
