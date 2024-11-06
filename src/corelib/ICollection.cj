package dependency_injection.corelib

/*
	Base interface for all collections, defining enumerators, size, and
	synchronization methods.
*/
public interface ICollection<T> <: Iterable<T> {
	prop count: Int

	prop isReadOnly: Bool

	func add(item: T): Unit

	func clear(): Unit

	func contains(predicate: (T) -> Bool): Bool

	/*
	CopyTo copies a collection into an Array, starting at a particular
	index into the array.
	*/
	func copyTo(array: Array<?T>, arrayIndex: Int): Unit

	func remove(predicate: (T) -> Bool): Bool
}
