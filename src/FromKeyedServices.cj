package dependency_injection

@Annotation
/*
	Indicates that the parameter should be bound using the keyed service registered with the specified key.
*/
public class FromKeyedServices {
	private let _key: HashableEquatable<?Any>

	/*
	The key of the keyed service to bind to.
	*/
	public prop key: HashableEquatable<?Any> {
		get() { _key }
	}

	/*
	Creates a new FromKeyedServicesAttribute instance.

	key: The key of the keyed service to bind to.
	*/
	public const init(key: HashableEquatable<?Any>) {
		_key = key
	}
}
