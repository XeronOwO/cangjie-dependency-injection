package dependency_injection.corelib

/*
	An IList is an ordered collection of objects.  The exact ordering
	is up to the implementation of the list, ranging from a sorted
	order to insertion order.
*/
public interface IList<T> <: ICollection<T> {
	/*
	The Item property provides methods to read entries in the List.
	*/
	operator func [](index: Int64): T

	/*
	The Item property provides methods to edit entries in the List.
	*/
	operator func [](index: Int64, value!: T): Unit
	
	/*
	Returns the index of a particular item, if it is in the list.
	Returns -1 if the item isn't in the list.
	*/
	func indexOf(predicate: (T) -> Bool): Int64

	/*
	Inserts value into the list at position index.
	index must be non-negative and less than or equal to the
	number of elements in the list.  If index equals the number
	of items in the list, then value is appended to the end.
	*/
	func insert(index: Int64, item: T): Unit

	/*
	Removes the item at position index.
	*/
	func removeAt(index: Int64): Unit
}
