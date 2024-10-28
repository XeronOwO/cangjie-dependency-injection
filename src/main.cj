package dependency_inject

import std.collection.*
import std.reflect.*

interface I1 <: ToString {
}

class C1 <: I1 {
	public func toString(): String {
		return "C1"
	}
}

interface I2 <: ToString {
}

class C2 <: I2 {
	private let _i1: I1
	public init(i1 : I1) {
		_i1 = i1
	}
	
	public func toString(): String {
		return "C2(${_i1})"
	}
}

interface I3 <: ToString {
}

class C3 <: I3 {
	private let _i1: I1
	private let _i2: I2
	public init(i1 : I1, i2 : I2) {
		_i1 = i1
		_i2 = i2
	}
	
	public func toString(): String {
		return "C3(${_i1}, ${_i2})"
	}
}

main(): Unit {
	let services = ServiceCollection()
	ServiceCollection.addTransient2<I1, C1>(services)
	ServiceCollection.addTransient2<I2, C2>(services)
	ServiceCollection.addTransient2<I3, C3>(services)
	let provider = ServiceProvider(services, ServiceProviderOptions())
	let i3 = IServiceProvider.getRequiredService1<I3>(provider)
	println(i3.toString())
}
