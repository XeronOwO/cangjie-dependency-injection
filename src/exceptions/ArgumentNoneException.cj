package dependency_injection.exceptions

import dependency_injection.resources.*

/*
	The exception that is thrown when a none reference is passed to a method that does not accept it as a valid argument.
*/
public class ArgumentNoneException <: ArgumentException {
	/*
	Creates a new ArgumentNoneException with its message
	string set to a default message explaining an argument was none.
	*/
	public init() {
		super(SR.ArgumentNone_Generic)
	}

	public init(paramName: ?String) {
		super(SR.Arg_ArgumentException, paramName)
	}

	public init(paramName: ?String, message: ?String) {
		super(message ?? SR.Arg_ArgumentException, paramName)
	}

	public override func getClassName(): String {
		"ArgumentNoneException"
	}
}
