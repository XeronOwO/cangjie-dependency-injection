package dependency_injection.abstractions

import dependency_injection.corelib.*

public class ServiceCollection <: IServiceCollection {
	private let _descriptors = List<ServiceDescriptor>()

	private var _isReadOnly = false

	public override prop count: Int {
		get() { _descriptors.count }
	}

	public override prop isReadOnly: Bool {
		get() { _isReadOnly }
	}

	public operator func [](index: Int64): ServiceDescriptor {
		return _descriptors[index]
	}

	public operator func [](index: Int64, value!: ServiceDescriptor): Unit {
		checkReadOnly()
		_descriptors[index] = value
	}

	public override func clear(): Unit {
		checkReadOnly()
		_descriptors.clear()
	}

	public override func contains(predicate: (ServiceDescriptor) -> Bool): Bool {
		return _descriptors.contains(predicate)
	}

	public override func copyTo(array: Array<?ServiceDescriptor>, arrayIndex: Int): Unit {
		_descriptors.copyTo(array, arrayIndex)
	}

	public override func remove(predicate: (ServiceDescriptor) -> Bool): Bool {
		checkReadOnly()
		return _descriptors.remove(predicate)
	}

	public override func iterator(): Iterator<ServiceDescriptor> {
		return _descriptors.iterator()
	}

	public override func add(item: ServiceDescriptor): Unit {
		checkReadOnly()
		_descriptors.add(item)
	}

	public override func indexOf(predicate: (ServiceDescriptor) -> Bool): Int64 {
		return _descriptors.indexOf(predicate)
	}

	public override func insert(index: Int64, item: ServiceDescriptor): Unit {
		checkReadOnly()
		_descriptors.insert(index, item)
	}

	public override func removeAt(index: Int64): Unit {
		checkReadOnly()
		_descriptors.removeAt(index)
	}

	/*
	Makes this collection read-only.
	After the collection is marked as read-only, any further attempt to modify it throws an InvalidOperationException.
	*/
	public func makeReadOnly(): Unit {
		_isReadOnly = true
	}

	private func checkReadOnly(): Unit {
		if (_isReadOnly) {
			throwReadOnlyException()
		}
	}

	private static func throwReadOnlyException(): Unit {
		throw InvalidOperationException(SR.ServiceCollectionReadOnly)
	}
}
