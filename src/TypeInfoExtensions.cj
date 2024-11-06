package dependency_injection

import std.reflect.*

extend TypeInfo {
	public func isInstanceOfType(value: Any): Bool {
		let typ = TypeInfo.of(value)
		if (typ == this) {
			return true
		}

		if (typ.isSubtypeOf(this)) {
			return true
		}

		return false
	}
	
	public prop isAbstract: Bool {
		get() {
			for (modifier in this.modifiers) {
				match (modifier) {
					case ModifierInfo.Abstract =>
						return true
					case _ =>
						continue
				}
			}
			return false
		}
	}

	public prop isInterface: Bool {
		get() {
			this is InterfaceTypeInfo
		}
	}
}
