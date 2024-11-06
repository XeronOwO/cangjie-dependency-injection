package dependency_injection.corelib

/*
	Provides a read-only, covariant view of a generic list.
*/
public interface IReadOnlyCollection<T> <: Iterable<T> {
	prop count: Int
}
