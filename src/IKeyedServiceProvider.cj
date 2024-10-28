package dependency_inject

import std.reflect.*

/*
	Retrieves services using a key and a type.
*/
public interface IKeyedServiceProvider {
	/*
	Gets the service object of the specified type.

	serviceType: An object that specifies the type of service object to get.
	serviceKey: An object that specifies the key of service object to get.

	returns: A service object of type serviceType.
	*/
	func getKeyedService(serviceType: TypeInfo, serviceKey: ?HashableEquatable<?Any>): ?Object

	/*
	Gets service of type serviceType from the IServiceProvider implementing
	this interface.

	serviceType: An object that specifies the type of service object to get.
	serviceKey: The ServiceDescriptor.ServiceKey of the service.

	returns: A service object of type serviceType.

	Throws an exception if the IServiceProvider cannot create the object.
	*/
	func getRequiredKeyedService(serviceType: TypeInfo, serviceKey: ?HashableEquatable<?Any>): Object
}

/*
	Provides static APIs for use with IKeyedServiceProvider.
*/
public class KeyedService {
	private static let _anyKey: HashableEquatable<?Any> = AnyKeyObj()

	public static prop AnyKey: HashableEquatable<?Any> {
		get() { _anyKey }
	}
	
}

private class AnyKeyObj <: ToString & HashableEquatable<?Any> {
	public func toString(): String {
		return "*"
	}

	public operator func ==(other: ?Any): Bool {
		if (other.isNone()) {
			return false
		}

		let otherObject = other.getOrThrow() as Object
		if (otherObject.isNone()) {
			return false
		}

		return refEq(this, otherObject.getOrThrow())
	}

	public func hashCode(): Int {
		return toString().hashCode()
	}
}
