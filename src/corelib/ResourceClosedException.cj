package dependency_injection.corelib

public class ResourceClosedException <: InvalidOperationException {
	private let _objectName: ?String

	public init() {
		this(None, SR.ResourceClosed_Generic)
	}

	public init(objectName: ?String) {
		this(objectName, SR.ResourceClosed_Generic)
	}

	public init(objectName: ?String, message: ?String) {
		super(message ?? SR.ResourceClosed_Generic)
		_objectName = objectName
	}

	public override func getClassName(): String {
		"ResourceClosedException"
	}
}
