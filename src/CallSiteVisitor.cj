package dependency_injection

internal abstract class CallSiteVisitor<TArgument, TResult> {
	protected init() {
		super()
	}

	protected open func visitCallSite(callSite: ServiceCallSite, argument: TArgument): TResult {
		match (callSite.cache.location) {
			case CallSiteResultCacheLocation.Root =>
				return visitRootCache(callSite, argument)
			case CallSiteResultCacheLocation.Scope =>
				return visitScopeCache(callSite, argument)
			case CallSiteResultCacheLocation.Resource =>
				return visitResourceCache(callSite, argument)
			case CallSiteResultCacheLocation.None =>
				return visitNoCache(callSite, argument)
		}
	}

	protected open func visitCallSiteMain(callsite: ServiceCallSite, argument: TArgument): TResult {
		match (callsite.kind) {
			case CallSiteKind.Factory =>
				return visitFactory((callsite as FactoryCallSite).getOrThrow(), argument)
			case CallSiteKind.Iterable =>
				return visitIterable((callsite as IterableCallSite).getOrThrow(), argument)
			case CallSiteKind.Constructor =>
				return visitConstructor((callsite as ConstructorCallSite).getOrThrow(), argument)
			case CallSiteKind.Constant =>
				return visitConstant((callsite as ConstantCallSite).getOrThrow(), argument)
			case CallSiteKind.ServiceProvider =>
				return visitServiceProvider((callsite as ServiceProviderCallSite).getOrThrow(), argument)
		}
	}

	protected open func visitNoCache(callSite: ServiceCallSite, argument: TArgument): TResult {
		return visitCallSiteMain(callSite, argument)
	}

	protected open func visitResourceCache(callSite: ServiceCallSite, argument: TArgument): TResult {
		return visitCallSiteMain(callSite, argument)
	}

	protected open func visitRootCache(callSite: ServiceCallSite, argument: TArgument): TResult {
		return visitCallSiteMain(callSite, argument)
	}

	protected open func visitScopeCache(callSite: ServiceCallSite, argument: TArgument): TResult {
		return visitCallSiteMain(callSite, argument)
	}

	protected open func visitConstructor(constructorCallSite: ConstructorCallSite, argument: TArgument): TResult

	protected open func visitConstant(constantCallSite: ConstantCallSite, argument: TArgument): TResult

	protected open func visitServiceProvider(serviceProviderCallSite: ServiceProviderCallSite, argument: TArgument): TResult

	protected open func visitIterable(iterableCallSite: IterableCallSite, argument: TArgument): TResult

	protected open func visitFactory(factoryCallSite: FactoryCallSite, argument: TArgument): TResult
}
