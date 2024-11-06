package dependency_injection.corelib

import std.collection.*
import std.unittest.*

/*
	Implements a variable-size List that uses an array of objects to store the
	elements. A List has a capacity, which is the allocated length
	of the internal array. As elements are added to a List, the capacity
	of the List is automatically increased as required by reallocating the
	internal array.
*/
public class List<T> <: IList<T> & IReadOnlyList<T> {
	private static const defaultCapacity = 4

	internal var _items: Array<?T>
	internal var _size: Int
	internal var _version: Int

	private static let s_emptyArray = Array<?T>()

	/*
	Constructs a List. The list is initially empty and has a capacity
	of zero. Upon adding the first element to the list the capacity is
	increased to DefaultCapacity, and then increased in multiples of two
	as required.
	*/
	public init() {
		_items = s_emptyArray;
		_size = 0;
		_version = 0;
	}

	/*
	Constructs a List with a given initial capacity. The list is
	initially empty, but will have room for the given number of elements
	before any reallocations are required.
	*/
	public init(capacity: Int) {
		if (capacity < 0) {
			ThrowHelper.throwArgumentOutOfRangeException(ExceptionArgument.capacity, ExceptionResource.ArgumentOutOfRange_NeedNonNegNum)
		}

		_size = 0;
		_version = 0;
		if (capacity == 0) {
			_items = s_emptyArray
		} else {
			_items = Array<?T>(capacity, repeat: None)
		}
	}

	/*
	Constructs a List with a given initial capacity. The list is
	initially empty, but will have room for the given number of elements
	before any reallocations are required.
	*/
	public init(collection: Iterable<T>) {
		_size = 0;
		_version = 0;

		let cOption = collection as ICollection<T>

		if (cOption.isSome()) {
			let c = cOption.getOrThrow()
			let count = c.count
			if (count == 0) {
				_items = s_emptyArray
			} else {
				_items = Array<?T>(count, repeat: None)
				c.copyTo(_items, 0)
				_size = count
			}
		} else {
			_items = s_emptyArray
			let it = collection.iterator()
			while (true) {
				let itemOption = it.next()
				if (itemOption.isNone()) {
					break
				}
				add(itemOption.getOrThrow())
			}
		}
	}

	public mut prop capacity: Int {
		get() {
			return _items.size
		}
		set(value) {
			if (value < _size) {
				ThrowHelper.throwArgumentOutOfRangeException(ExceptionArgument.value, ExceptionResource.ArgumentOutOfRange_SmallCapacity)
			}

			if (value != _items.size) {
				if (value > 0) {
					let newItems = Array<?T>(value, repeat: None)
					if (_size > 0) {
						_items.copyTo(newItems, 0, 0, _size)
					}
					_items = newItems
				} else {
					_items = s_emptyArray
				}
			}
		}
	}

	/*
	Read-only property describing how many elements are in the List.
	*/
	public override prop count: Int {
		get() { _size }
	}

	/*
	Is this List read-only?
	*/
	public override prop isReadOnly: Bool {
		get() { false }
	}

	/*
	Gets the element at the given index.
	*/
	public override operator func [](index: Int64): T {
		//Following trick can reduce the range check by one
		if (index >= _size) {
			ThrowHelper.throwArgumentOutOfRange_IndexMustBeLessException()
		}
		return _items[index].getOrThrow()
	}

	/*
	Sets the element at the given index.
	*/
	public override operator func [](index: Int64, value!: T): Unit {
		if (index >= _size) {
			ThrowHelper.throwArgumentOutOfRange_IndexMustBeLessException()
		}
		_items[index] = value
		_version++
	}

	/*
	Adds the given object to the end of this list. The size of the list is
	increased by one. If required, the capacity of the list is doubled
	before adding the new element.
	*/
	public override func add(item: T): Unit {
		_version++
		let array = _items
		let size = _size
		if (size < array.size) {
			_size = size + 1
			array[size] = item
		} else {
			addWithResize(item)
		}
	}

	private func addWithResize(item: T) {
		Debug.assert(_size == _items.size)
		let size = _size
		grow(size + 1)
		_size = size + 1
		_items[size] = item
	}

	/*
	Adds the elements of the given collection to the end of this list. If
	required, the capacity of the list is increased to twice the previous
	capacity or the new size, whichever is larger.
	*/
	public func addRange(collection: Iterator<T>) {
		let cOption = collection as ICollection<T>
		if (cOption.isSome()) {
			let c = cOption.getOrThrow()
			let count = c.count
			if (count > 0)
			{
				if (_items.size - _size < count) {
					grow(_size + count)
				}

				c.copyTo(_items, _size)
				_size += count
				_version++
			}
		} else {
			let it = collection.iterator()
			while (true) {
				let itemOption = it.next()
				if (itemOption.isNone()) {
					break
				}
				add(itemOption.getOrThrow())
			}
		}
	}

	/*
	Clears the contents of List.
	*/
	public override func clear(): Unit {
		_version++

		let size = _size
		_size = 0
		if (size > 0) {
			Array<T>.clear(_items, 0, size)
		}
	}

	public override func contains(predicate: (T) -> Bool): Bool {
		return _size != 0 && indexOf(predicate) >= 0
	}

	/*
	Increase the capacity of this list to at least the specified capacity.

	capacity: The minimum capacity to ensure.
	*/
	internal func grow(capacity: Int) {
		this.capacity = getNewCapacity(capacity);
	}

	/*
	Enlarge this list so it may contain at least insertionCount more elements
	And copy data to their after-insertion positions.
	This method is specifically for insertion, as it avoids 1 extra array copy.
	You should only call this method when Count + insertionCount > Capacity.

	indexToInsert: Index of the first insertion.
	insertionCount: How many elements will be inserted.
	*/
	private func growForInsertion(indexToInsert: Int, insertionCount!: Int = 1) {
		Debug.assert(insertionCount > 0)

		let requiredCapacity = _size + insertionCount
		let newCapacity = getNewCapacity(requiredCapacity)

		// Inline and adapt logic from set_Capacity

		let newItems = Array<?T>(newCapacity, repeat: None)
		if (indexToInsert != 0) {
			_items.copyTo(newItems, 0, 0, indexToInsert)
		}

		if (_size != indexToInsert) {
			_items.copyTo(newItems, indexToInsert, indexToInsert, indexToInsert + insertionCount)
		}

		_items = newItems
	}

	private func getNewCapacity(capacity: Int): Int {
		Debug.assert(_items.size < capacity)

		var newCapacity: Int
		if (_items.size == 0) {
			newCapacity = defaultCapacity
		} else {
			newCapacity = 2 * _items.size
		}

		if (newCapacity > Array<T>.maxLength) {
			newCapacity = Array<T>.maxLength
		}

		if (newCapacity < capacity) {
			newCapacity = capacity
		}

		return newCapacity
	}

	public override func indexOf(predicate: (T) -> Bool): Int64 {
		return indexOf(predicate, 0)
	}

	public func indexOf(predicate: (T) -> Bool, index: Int): Int64 {
		while (index < _items.size) {
			if (predicate(_items[index].getOrThrow())) {
				return index
			}
		}
		return -1
	}

	public override func insert(index: Int64, item: T): Unit {
		// Note that insertions at the end are legal.
		if (index > _size) {
			ThrowHelper.throwArgumentOutOfRangeException(ExceptionArgument.index, ExceptionResource.ArgumentOutOfRange_ListInsert);
		}
		if (_size == _items.size) {
			growForInsertion(index, insertionCount: 1)
		} else if (index < _size) {
			_items.copyTo(_items, index, index + 1, _size - index)
		}
		_items[index] = item
		_size++
		_version++
	}

	public override func remove(predicate: (T) -> Bool): Bool {
		let index = indexOf(predicate)
		if (index >= 0) {
			removeAt(index)
			return true
		}

		return false
	}

	public override func removeAt(index: Int64): Unit {
		if (index >= _size) {
			ThrowHelper.throwArgumentOutOfRange_IndexMustBeLessException()
		}
		_size--
		if (index < _size) {
			_items.copyTo(_items, index + 1, index, _size - index)
		}
		_items[_size] = None
		_version++
	}

	public override func copyTo(array: Array<?T>, arrayIndex: Int): Unit {
		_items.copyTo(array, 0, arrayIndex, _size)
	}

	public override func iterator(): Iterator<T> {
		return ListIterator<T>(this)
	}
}

extend<T> List<T> where T <: Equatable<T> {
	public func indexOf(item: T): Int64 {
		return indexOf({ v => v == item })
	}
	
	public func remove(item: T): Bool {
		return remove({ v => v == item })
	}
}

public class ListIterator<T> <: Iterator<T> {
	private let _list: List<T>
	private var _index: Int
	private let _version: Int
	private var _current: ?T

	internal init(list: List<T>) {
		_list = list
		_index = 0
		_version = list._version
		_current = None
	}

	public override func next(): ?T {
		let localList = _list
		if (_version == localList._version && _index < localList._size) {
			_current = localList._items[_index]
			_index++
			return _current
		}

		nextRare()

		return _current
	}

	private func nextRare(): Unit {
		if (_version != _list._version) {
			ThrowHelper.throwInvalidOperationException_InvalidOperation_EnumFailedVersion()
		}

		_index = _list._size + 1
		_current = None
	}
}
