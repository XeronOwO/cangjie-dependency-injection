package dependency_injection

internal enum CallSiteKind {
	| Factory
	| Constructor
	| Constant
	| Iterable
	| ServiceProvider
}
