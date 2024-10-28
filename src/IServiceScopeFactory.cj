package dependency_inject

/*
	Creates instances of IServiceScope, which is used to create
	services within a scope.
*/
public interface IServiceScopeFactory {
	/*
	Create an IServiceScope that
	contains an IServiceProvider used to resolve dependencies from a
	newly created scope.
	</summary>
	<returns>
	An IServiceScope controlling the
	lifetime of the scope. Once this is disposed, any scoped services that have been resolved
	from the ServiceProvider
	will also be disposed.
	*/
	func createScope(): IServiceScope
}
