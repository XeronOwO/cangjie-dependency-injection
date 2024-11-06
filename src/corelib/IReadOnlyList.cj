package dependency_injection.corelib

/*
	Provides a read-only, covariant view of a generic list.
*/
public interface IReadOnlyList<T> <: IReadOnlyCollection<T> {
	operator func [](index: Int64): T
}
