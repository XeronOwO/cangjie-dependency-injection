package dependency_injection.exceptions

import dependency_injection.resources.*
import std.collection.*

/*
	Represents one or more errors that occur during application execution.

	AggregateException is used to consolidate multiple failures into a single, throwable
	exception object.
*/
public class AggregateException <: Exception {
	private let _innerExceptions: Array<Exception>

	/*
	Initializes a new instance of the AggregateException class.
	*/
	public init() {
		super(SR.AggregateException_ctor_DefaultMessage)
		_innerExceptions = Array()
	}

	/*
	Initializes a new instance of the AggregateException class with
	a specified error message.

	message: The error message that explains the reason for the exception.
	*/
	public init(message: ?String) {
		super(message ?? SR.AggregateException_ctor_DefaultMessage)
		_innerExceptions = Array()
	}

	/*
	Initializes a new instance of the AggregateException class with a specified error
	message and a reference to the inner exception that is the cause of this exception.

	message: The error message that explains the reason for the exception.
	innerException: The exception that is the cause of the current exception.
	*/
	public init(message: ?String, innerException: Exception) {
		super(message ?? SR.AggregateException_ctor_DefaultMessage)
		_innerExceptions = [innerException]
	}

	/*
	Initializes a new instance of the AggregateException class with
	references to the inner exceptions that are the cause of this exception.

	innerExceptions: The exceptions that are the cause of the current exception.
	*/
	public init(innerExceptions: Iterable<Exception>) {
		this(SR.AggregateException_ctor_DefaultMessage, innerExceptions)
	}

	/*
	Initializes a new instance of the AggregateException class with a specified error
	message and references to the inner exceptions that are the cause of this exception.

	message: The error message that explains the reason for the exception.
	innerExceptions: The exceptions that are the cause of the current exception.
	*/
	public init(message: ?String, innerExceptions: Iterable<Exception>) {
		this(
			message,
			ArrayList<Exception>(
				innerExceptions.iterator().count(), {
					index => innerExceptions.iterator().at(index).getOrThrow()
				}
			).toArray(),
			true
		)
	}

	private init(message: ?String, innerExceptions: Array<Exception>, cloneExceptions: Bool) {
		super(message ?? SR.AggregateException_ctor_DefaultMessage)
		if (cloneExceptions) {
			_innerExceptions = innerExceptions.clone()
		} else {
			_innerExceptions = innerExceptions
		}
	}

	public override prop message: String {
		get() {
			if (_innerExceptions.isEmpty()) {
				return super.message
			}

			let sb = StringBuilder()
			sb.append(super.message)
			sb.append(' ')
			for (exception in _innerExceptions) {
				sb.append('(')
				sb.append(exception.message)
				sb.append(')')
			}
			return sb.toString()
		}
	}
}
