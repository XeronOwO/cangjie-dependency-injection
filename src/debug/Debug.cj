package dependency_inject.debug

import logger.*
import std.console.*

public class Debug {
	private static let _logger = SimpleLogger(Console.stdOut)

	@When[debug]
	public static func assert(condition: Bool) {
		assert(condition, "")
	}

	@When[!debug]
	public static func assert(condition: Bool) {}

	@When[debug]
	public static func assert(condition: Bool, message: ?String) {
		if (!condition) {
			fail(message)
		}
	}

	@When[!debug]
	public static func assert(condition: Bool, message: ?String) {}

	@When[debug]
	public static func fail(message: ?String) {
		_logger.fatal(message ?? "")
		throw Exception(message ?? "")
	}

	@When[!debug]
	public static func fail(message: ?String) {}
}
