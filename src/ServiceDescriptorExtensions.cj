package dependency_injection

import std.reflect.*

extend ServiceDescriptor {
	public func hasImplementationInstance(): Bool {
		getImplementationInstance().isSome()
	}

	public func hasImplementationFactory(): Bool {
		getImplementationFactory().isSome()
	}

	public func hasImplementationType(): Bool {
		getImplementationType().isSome()
	}

	public func getImplementationInstance(): ?Object {
		if (isKeyedService) {
			return keyedImplementationInstance
		} else {
			return implementationInstance
		}
	}

	public func getImplementationFactory(): ?Any {
		if (isKeyedService) {
			if (keyedImplementationFactory.isNone()) {
				return None
			}
			return keyedImplementationFactory.getOrThrow()
		} else {
			if (implementationFactory.isNone()) {
				return None
			}
			return implementationFactory.getOrThrow()
		}
	}

	public func getImplementationType(): ?TypeInfo {
		if (isKeyedService) {
			return keyedImplementationType
		} else {
			return implementationType
		}
	}

	public func tryGetImplementationType(): (Bool, ?TypeInfo) {
		let typ = getImplementationType()
		return (typ.isSome(), typ)
	}
}
