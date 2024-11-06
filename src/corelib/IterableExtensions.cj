package dependency_injection.corelib

public class IterableExtensions {
	public static func toArray<T>(t: Iterable<T>): Array<T> {
		let count = t.iterator().count()
		let it = t.iterator()
		return Array<T>(count, {
			_ => it.next().getOrThrow()
		})
	}
}
