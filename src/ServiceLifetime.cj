package dependency_injection

import std.reflect.*

/*
	Specifies the lifetime of a service in an IServiceCollection.
*/
public enum ServiceLifetime <: ToString {
	/*
	Specifies that a single instance of the service will be created.
	*/
	| Singleton

	/*
	Specifies that a new instance of the service will be created for each scope.
	*/
	| Scoped

	/*
	Specifies that a new instance of the service will be created every time it is requested.
	*/
	| Transient

	public func toString(): String {
		return match (this) {
			case Singleton => "Singleton"
			case Scoped => "Scoped"
			case Transient => "Transient"
		}
	}
}
