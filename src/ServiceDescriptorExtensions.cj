package dependency_injection

import dependency_injection.abstractions.*
import std.reflect.*

extend ServiceDescriptor {
	public func hasImplementationInstance(): Bool {
		return getImplementationInstance().isSome()
	}

	public func hasImplementationFactory(): Bool {
		return getImplementationFactory().isSome()
	}

	public func hasImplementationType(): Bool {
		return getImplementationType().isSome()
	}

	public func getImplementationInstance(): ?Object {
		if (isKeyedService) {
			return keyedImplementationInstance
		}
		return implementationInstance
	}

	public func getImplementationFactory(): ?Any {
		if (isKeyedService) {
			if (let Some(factory) <- keyedImplementationFactory) {
				return factory
			}
			return None
		}

		if (let Some(factory) <- implementationFactory) {
			return factory
		}
		return None
	}

	public func getImplementationType(): ?TypeInfo {
		if (isKeyedService) {
			return keyedImplementationType
		}
		return implementationType
	}

	public func tryGetImplementationType(): (Bool, ?TypeInfo) {
		let typ = getImplementationType()
		let flag = typ.isSome()
		return (flag, typ)
	}
}
