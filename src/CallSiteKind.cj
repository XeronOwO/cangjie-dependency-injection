package dependency_inject

internal enum CallSiteKind {
	| Factory
	| Constructor
	| Constant
	| Iterable
	| ServiceProvider
}
