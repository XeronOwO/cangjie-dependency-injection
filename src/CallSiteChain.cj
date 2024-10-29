package dependency_injection

import dependency_injection.exceptions.*
import dependency_injection.resources.*
import dependency_injection.runtime.*
import std.collection.*
import std.reflect.*

internal class CallSiteChain {
	private let _callSiteChain: HashMap<ServiceIdentifier, ChainItemInfo>
	
	public init() {
		_callSiteChain = HashMap()
	}

	public func checkCircularDependency(serviceIdentifier: ServiceIdentifier) {
		if (_callSiteChain.contains(serviceIdentifier)) {
			throw InvalidOperationException(createCircularDependencyExceptionMessage(serviceIdentifier))
		}
	}

	public func remove(serviceIdentifier: ServiceIdentifier) {
		_callSiteChain.remove(serviceIdentifier)
	}

	public func add(serviceIdentifier: ServiceIdentifier, implementationType!: ?TypeInfo = None) {
		_callSiteChain[serviceIdentifier] = ChainItemInfo(_callSiteChain.size, implementationType)
	}

	private func createCircularDependencyExceptionMessage(serviceIdentifier: ServiceIdentifier): String {
		var messageBuilder = StringBuilder()
		messageBuilder.append(SR.format(SR.CircularDependencyException, [serviceIdentifier.serviceType.name]))
		messageBuilder.append(Environment.newLine)

		appendResolutionPath(messageBuilder, serviceIdentifier)

		return messageBuilder.toString()
	}

	private func appendResolutionPath(builder: StringBuilder, currentlyResolving: ServiceIdentifier) {
		var ordered = ArrayList<(ServiceIdentifier, ChainItemInfo)>(_callSiteChain)
		ordered.sortBy(stable: false, comparator: { a, b => a[1].order.compare(b[1].order) })

		for (tuple in ordered) {
			let serviceIdentifier = tuple[0]
			let implementationType = tuple[1].implementationType
			if (implementationType.isNone() || refEq(serviceIdentifier.serviceType, implementationType.getOrThrow())) {
				builder.append(serviceIdentifier.serviceType.name)
			} else {
				builder.append(serviceIdentifier.serviceType.name)
				builder.append("(")
				builder.append(implementationType.getOrThrow().name)
				builder.append(")")
			}

			builder.append(" -> ")
		}

		builder.append(currentlyResolving.serviceType.name)
	}
}

internal struct ChainItemInfo {
	private let _order: Int

	public prop order: Int {
		get() { _order }
	}

	private let _implementationType: ?TypeInfo

	public prop implementationType: ?TypeInfo {
		get() { _implementationType }
	}

	public init(order: Int, implementationType: ?TypeInfo) {
		_order = order
		_implementationType = implementationType
	}
}
