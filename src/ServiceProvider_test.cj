package dependency_inject

import dependency_inject.exceptions.*
import std.reflect.*
import std.unittest.*

@When[test]
private interface Interface1 <: ToString {}

@When[test]
private class Class1 <: Interface1 {
	public func toString(): String { "Class1" }
}

@When[test]
private interface Interface2 <: ToString {}

@When[test]
private class Class2 <: Interface2 {
	private let _i1: Interface1

	public init(i1: Interface1) {
		_i1 = i1
	}

	public func toString(): String { "Class2(${_i1})" }
}

@When[test]
private interface Interface3 <: ToString {}

@When[test]
private class Class3 <: Interface3 {
	private let _i1: Interface1
	private let _i2: Interface2

	public init(i1: Interface1, i2: Interface2) {
		_i1 = i1
		_i2 = i2
	}

	public func toString(): String { "Class3(${_i1}, ${_i2})" }
}

@Test
private class ServiceProviderTest {
	/*
	Test case naming policy:

	- Transient/Scoped/Singleton: Service lifetime.

	- Unrelated: Registered with service type only.
	- Related:   Registered with service type and implementation type.

	- Object: Returns the service type as Object.
	- T:      Returns the service type as T.

	- NoInject: No constructor injection.
	- Inject:   Constructor injection.
	*/

	@TestCase
	func transientUnrelatedObjectNoInject() {
		let interface1Type = TypeInfo.of<Interface1>()
		let class1Type = TypeInfo.of<Class1>()

		let services = ServiceCollection()
		services.addTransient(class1Type)
		let provider = ServiceProvider(services, ServiceProviderOptions())
		
		let objectOption_1 = provider.getService(class1Type)
		@Expect(objectOption_1.isSome())
		let class1Option_1 = objectOption_1.getOrThrow() as Class1
		@Expect(class1Option_1.isSome())
		let class1_1 = class1Option_1.getOrThrow()
		@Expect(class1_1.toString() == "Class1")
		
		let class1Option_2 = provider.getRequiredService(class1Type) as Class1
		@Expect(class1Option_2.isSome())
		let class1_2 = class1Option_2.getOrThrow()
		@Expect(class1_2.toString() == "Class1")

		@Expect(!refEq(class1_1, class1_2))

		let interface1ObjectOption = provider.getService(interface1Type)
		@Expect(interface1ObjectOption.isNone())

		@ExpectThrows[InvalidOperationException](provider.getRequiredService(interface1Type))
	}

	@TestCase
	func transientUnrelatedTNoInject() {
		let services = ServiceCollection()
		IServiceCollection.addTransient1<Class1>(services)
		let provider = ServiceProvider(services, ServiceProviderOptions())
		
		let class1Option_1 = IServiceProvider.getService1<Class1>(provider)
		@Expect(class1Option_1.isSome())
		let class1_1 = class1Option_1.getOrThrow()
		@Expect(class1_1.toString() == "Class1")
		
		let class1_2 = IServiceProvider.getRequiredService1<Class1>(provider)
		@Expect(class1_2.toString() == "Class1")

		@Expect(!refEq(class1_1, class1_2))

		let interface1Option = IServiceProvider.getService1<Interface1>(provider)
		@Expect(interface1Option.isNone())

		@ExpectThrows[InvalidOperationException](IServiceProvider.getRequiredService1<Interface1>(provider))
	}
}
