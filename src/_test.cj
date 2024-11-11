package dependency_injection

import dependency_injection.abstractions.*
import dependency_injection.component_model.*
import dependency_injection.corelib.*
import std.reflect.*
import std.unittest.*

/***
 *    ████████╗███████╗███████╗████████╗██╗███╗   ██╗ ██████╗     ████████╗██╗   ██╗██████╗ ███████╗███████╗
 *    ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██║████╗  ██║██╔════╝     ╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔════╝
 *       ██║   █████╗  ███████╗   ██║   ██║██╔██╗ ██║██║  ███╗       ██║    ╚████╔╝ ██████╔╝█████╗  ███████╗
 *       ██║   ██╔══╝  ╚════██║   ██║   ██║██║╚██╗██║██║   ██║       ██║     ╚██╔╝  ██╔═══╝ ██╔══╝  ╚════██║
 *       ██║   ███████╗███████║   ██║   ██║██║ ╚████║╚██████╔╝       ██║      ██║   ██║     ███████╗███████║
 *       ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝        ╚═╝      ╚═╝   ╚═╝     ╚══════╝╚══════╝
 *                                                                                                          
 *    Sorted by alphabetical order.
 */

@When[test]
class FakeService <: IFakeEveryService & Resource {
	private var _value: ?PocoClass = None

	public override prop value: ?PocoClass {
		get() { _value }
	}

	public mut prop valueExt: ?PocoClass {
		get() { _value }
		set(value) { _value = value }
	}

	private var _isClosed = false

	public override func isClosed(): Bool {
		return _isClosed
	}

	public override func close() {
		if (_isClosed) {
			throw ResourceClosedException("FakeService")
		}

		_isClosed = true
	}
}

@When[test]
interface IFakeEveryService
	<: IFakeService
	 & IFakeMultipleService
	 & IFakeScopedService
	 & IFakeServiceInstance
	 & IFakeSingletonService
	 & IFakeOpenGenericService<PocoClass> {
}

@When[test]
interface IFakeMultipleService <: IFakeService {
}

@When[test]
interface IFakeOpenGenericService<T> {
	prop value: ?T
}

@When[test]
interface IFakeScopedService <: IFakeService {
}

@When[test]
interface IFakeService {
}

@When[test]
interface IFakeServiceInstance <: IFakeService {
}

@When[test]
interface IFakeSingletonService <: IFakeService {
}

@When[test]
class PocoClass {
}

/***
 *    ████████╗███████╗███████╗████████╗███████╗
 *    ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██╔════╝
 *       ██║   █████╗  ███████╗   ██║   ███████╗
 *       ██║   ██╔══╝  ╚════██║   ██║   ╚════██║
 *       ██║   ███████╗███████║   ██║   ███████║
 *       ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚══════╝
 *                                              
 *    Sorted by alphabetical order.
 */

@Test
class ServiceCollectionTests {
	@TestCase
	func testMakeReadOnly() {
		let serviceCollection = ServiceCollection()
		let descriptor = ServiceDescriptor(TypeInfo.of<IFakeService>(), FakeService())
		serviceCollection.add(descriptor)

		serviceCollection.makeReadOnly()

		let descriptor2 = ServiceDescriptor(TypeInfo.of<IFakeEveryService>(), FakeService())

		@ExpectThrows[InvalidOperationException](serviceCollection[0] = descriptor2)
		@ExpectThrows[InvalidOperationException](serviceCollection.clear())
		@ExpectThrows[InvalidOperationException](serviceCollection.remove({ d => refEq(d, descriptor) }))
		@ExpectThrows[InvalidOperationException](serviceCollection.add(descriptor2))
		@ExpectThrows[InvalidOperationException](serviceCollection.insert(0, descriptor2))
		@ExpectThrows[InvalidOperationException](serviceCollection.removeAt(0))

		@Expect(serviceCollection.isReadOnly)
		@Expect(serviceCollection.count == 1)
		for (d in serviceCollection) {
			@Expect(refEq(d, descriptor))
		}
		@Expect(refEq(descriptor, serviceCollection[0]))
		@Expect(serviceCollection.contains({ d => refEq(d, descriptor) }))
		@Expect(serviceCollection.indexOf({ d => refEq(d, descriptor) }) == 0)

		let copyArray = Array<?ServiceDescriptor>(1, repeat: Option<ServiceDescriptor>.None)
		serviceCollection.copyTo(copyArray, 0)
		@Expect(refEq(descriptor, copyArray[0].getOrThrow()))

		// ensure MakeReadOnly can be called twice, and it is just ignored
		serviceCollection.makeReadOnly()
		@Expect(serviceCollection.isReadOnly)
	}
}

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
class ServiceProviderTest {
	/*
	Test case naming policy:

	- Transient/Scoped/Singleton: Service lifetime.

	- Unrelated: Registered with service type only.
	- Related:   Registered with service type and implementation type.

	- Object:    Returns the service type as Object.
	- T:         Returns the service type as T.

	- NoInject:  No constructor injection.
	- Inject:    Constructor injection.

	- Keyed:     With service key.

	- Factory:   With factory method.
	*/

	// @TestCase
	// func transientUnrelatedObjectNoInject() {
	// 	let interface1Type = TypeInfo.of<Interface1>()
	// 	let class1Type = TypeInfo.of<Class1>()

	// 	let services = ServiceCollection()
	// 	services.addTransient(class1Type)
	// 	let provider = services.buildServiceProvider()
		
	// 	let objectOption_1 = provider.getService(class1Type)
	// 	@Expect(objectOption_1.isSome())
	// 	let class1Option_1 = objectOption_1.getOrThrow() as Class1
	// 	@Expect(class1Option_1.isSome())
	// 	let class1_1 = class1Option_1.getOrThrow()
	// 	@Expect(class1_1.toString() == "Class1")
		
	// 	let class1Option_2 = provider.getRequiredService(class1Type) as Class1
	// 	@Expect(class1Option_2.isSome())
	// 	let class1_2 = class1Option_2.getOrThrow()
	// 	@Expect(class1_2.toString() == "Class1")

	// 	@Expect(!refEq(class1_1, class1_2))

	// 	@Expect(provider.getService(interface1Type).isNone())
	// 	@ExpectThrows[InvalidOperationException](provider.getRequiredService(interface1Type))
	// }

	// @TestCase
	// func transientRelatedObjectNoInject() {
	// 	let interface1Type = TypeInfo.of<Interface1>()
	// 	let class1Type = TypeInfo.of<Class1>()

	// 	let services = ServiceCollection()
	// 	services.addTransient(interface1Type, class1Type)
	// 	let provider = services.buildServiceProvider()
		
	// 	let objectOption_1 = provider.getService(interface1Type)
	// 	@Expect(objectOption_1.isSome())
	// 	let interface1Option_1 = objectOption_1.getOrThrow() as Interface1
	// 	@Expect(interface1Option_1.isSome())
	// 	let interface1_1 = interface1Option_1.getOrThrow()
	// 	@Expect(interface1_1.toString() == "Class1")
		
	// 	let interface1Option_2 = provider.getRequiredService(interface1Type) as Interface1
	// 	@Expect(interface1Option_2.isSome())
	// 	let interface1_2 = interface1Option_2.getOrThrow()
	// 	@Expect(interface1_2.toString() == "Class1")

	// 	@Expect(!refEq((interface1_1 as Object).getOrThrow(), (interface1_2 as Object).getOrThrow()))

	// 	@Expect(provider.getService(class1Type).isNone())
	// 	@ExpectThrows[InvalidOperationException](provider.getRequiredService(class1Type))
	// }

	@TestCase
	func transientRelatedObjectInject() {
		let interface1Type = TypeInfo.of<Interface1>()
		let class1Type = TypeInfo.of<Class1>()
		let interface2Type = TypeInfo.of<Interface2>()
		let class2Type = TypeInfo.of<Class2>()
		let interface3Type = TypeInfo.of<Interface3>()
		let class3Type = TypeInfo.of<Class3>()

		let services = ServiceCollection()
		ServiceCollectionServiceExtensions.addTransient(services, interface1Type, class1Type)
		ServiceCollectionServiceExtensions.addTransient(services, interface2Type, class2Type)
		ServiceCollectionServiceExtensions.addTransient(services, interface3Type, class3Type)
		let provider = ServiceCollectionContainerBuilderExtensions.buildServiceProvider(services)
		
		let objectOption_1 = provider.getService(interface3Type)
		@Expect(objectOption_1.isSome())
		let interface3Option_1 = objectOption_1.getOrThrow() as Interface3
		@Expect(interface3Option_1.isSome())
		let interface3_1 = interface3Option_1.getOrThrow()
		@Expect(interface3_1.toString() == "Class3(Class1, Class2(Class1))")
		
		let interface3Option_2 = ServiceProviderServiceExtensions.getRequiredService(provider, interface3Type) as Interface3
		@Expect(interface3Option_2.isSome())
		let interface3_2 = interface3Option_2.getOrThrow()
		@Expect(interface3_2.toString() == "Class3(Class1, Class2(Class1))")

		@Expect(!refEq((interface3_1 as Object).getOrThrow(), (interface3_2 as Object).getOrThrow()))

		@Expect(provider.getService(class1Type).isNone())
		@Expect(provider.getService(class2Type).isNone())
		@Expect(provider.getService(class3Type).isNone())
		@ExpectThrows[InvalidOperationException](ServiceProviderServiceExtensions.getRequiredService(provider, class1Type))
		@ExpectThrows[InvalidOperationException](ServiceProviderServiceExtensions.getRequiredService(provider, class2Type))
		@ExpectThrows[InvalidOperationException](ServiceProviderServiceExtensions.getRequiredService(provider, class3Type))
	}

	// @TestCase
	// func transientUnrelatedTNoInject() {
	// 	let services = ServiceCollection()
	// 	IServiceCollection.addTransient1<Class1>(services)
	// 	let provider = services.buildServiceProvider()
		
	// 	let class1Option_1 = IServiceProvider.getService1<Class1>(provider)
	// 	@Expect(class1Option_1.isSome())
	// 	let class1_1 = class1Option_1.getOrThrow()
	// 	@Expect(class1_1.toString() == "Class1")
		
	// 	let class1_2 = IServiceProvider.getRequiredService1<Class1>(provider)
	// 	@Expect(class1_2.toString() == "Class1")

	// 	@Expect(!refEq(class1_1, class1_2))

	// 	@Expect(IServiceProvider.getService1<Interface1>(provider).isNone())
	// 	@ExpectThrows[InvalidOperationException](IServiceProvider.getRequiredService1<Interface1>(provider))
	// }

	// @TestCase
	// func transientRelatedTNoInject() {
	// 	let services = ServiceCollection()
	// 	IServiceCollection.addTransient2<Interface1, Class1>(services)
	// 	let provider = services.buildServiceProvider()
		
	// 	let interface1Option_1 = IServiceProvider.getService1<Interface1>(provider)
	// 	@Expect(interface1Option_1.isSome())
	// 	let interface1_1 = interface1Option_1.getOrThrow()
	// 	@Expect(interface1_1.toString() == "Class1")
		
	// 	let interface1_2 = IServiceProvider.getRequiredService1<Interface1>(provider)
	// 	@Expect(interface1_2.toString() == "Class1")

	// 	@Expect(!refEq((interface1_1 as Object).getOrThrow(), (interface1_2 as Object).getOrThrow()))

	// 	@Expect(IServiceProvider.getService1<Class1>(provider).isNone())
	// 	@ExpectThrows[InvalidOperationException](IServiceProvider.getRequiredService1<Class1>(provider))
	// }

	// @TestCase
	// func transientRelatedTInject() {
	// 	let services = ServiceCollection()
	// 	IServiceCollection.addTransient2<Interface1, Class1>(services)
	// 	IServiceCollection.addTransient2<Interface2, Class2>(services)
	// 	IServiceCollection.addTransient2<Interface3, Class3>(services)
	// 	let provider = services.buildServiceProvider()
		
	// 	let interface3Option_1 = IServiceProvider.getService1<Interface3>(provider)
	// 	@Expect(interface3Option_1.isSome())
	// 	let interface3_1 = interface3Option_1.getOrThrow()
	// 	@Expect(interface3_1.toString() == "Class3(Class1, Class2(Class1))")
		
	// 	let interface3_2 = IServiceProvider.getRequiredService1<Interface3>(provider)
	// 	@Expect(interface3_2.toString() == "Class3(Class1, Class2(Class1))")

	// 	@Expect(!refEq((interface3_1 as Object).getOrThrow(), (interface3_2 as Object).getOrThrow()))

	// 	@Expect(IServiceProvider.getService1<Class1>(provider).isNone())
	// 	@Expect(IServiceProvider.getService1<Class2>(provider).isNone())
	// 	@Expect(IServiceProvider.getService1<Class3>(provider).isNone())
	// 	@ExpectThrows[InvalidOperationException](IServiceProvider.getRequiredService1<Class1>(provider))
	// 	@ExpectThrows[InvalidOperationException](IServiceProvider.getRequiredService1<Class2>(provider))
	// 	@ExpectThrows[InvalidOperationException](IServiceProvider.getRequiredService1<Class3>(provider))
	// }

	// @TestCase
	// func scopeUnrelatedObjectNoInject() {
	// 	let interface1Type = TypeInfo.of<Interface1>()
	// 	let class1Type = TypeInfo.of<Class1>()

	// 	let services = ServiceCollection()
	// 	services.addScoped(class1Type)
	// 	let provider = services.buildServiceProvider()
	// 	let scopeFactory = IServiceProvider.getRequiredService1<IServiceScopeFactory>(provider)
	// 	let scope1 = scopeFactory.createScope()
	// 	let scope2 = scopeFactory.createScope()
		
	// 	let objectOption_1 = scope1.serviceProvider.getService(class1Type)
	// 	@Expect(objectOption_1.isSome())
	// 	let class1Option_1 = objectOption_1.getOrThrow() as Class1
	// 	@Expect(class1Option_1.isSome())
	// 	let class1_1 = class1Option_1.getOrThrow()
	// 	@Expect(class1_1.toString() == "Class1")
		
	// 	let class1Option_2 = scope1.serviceProvider.getRequiredService(class1Type) as Class1
	// 	@Expect(class1Option_2.isSome())
	// 	let class1_2 = class1Option_2.getOrThrow()
	// 	@Expect(class1_2.toString() == "Class1")
		
	// 	let class1Option_3 = scope2.serviceProvider.getRequiredService(class1Type) as Class1
	// 	@Expect(class1Option_3.isSome())
	// 	let class1_3 = class1Option_3.getOrThrow()
	// 	@Expect(class1_3.toString() == "Class1")

	// 	@Expect(refEq(class1_1, class1_2))
	// 	@Expect(!refEq(class1_2, class1_3))

	// 	scope1.close()
	// 	scope2.close()

	// 	@Expect(provider.getService(interface1Type).isNone())
	// 	@ExpectThrows[InvalidOperationException](provider.getRequiredService(interface1Type))
	// }

	// @TestCase
	// func scopeRelatedObjectNoInject() {
	// 	let interface1Type = TypeInfo.of<Interface1>()
	// 	let class1Type = TypeInfo.of<Class1>()

	// 	let services = ServiceCollection()
	// 	services.addScoped(interface1Type, class1Type)
	// 	let provider = services.buildServiceProvider()
	// 	let scopeFactory = IServiceProvider.getRequiredService1<IServiceScopeFactory>(provider)
	// 	let scope1 = scopeFactory.createScope()
	// 	let scope2 = scopeFactory.createScope()
		
	// 	let objectOption_1 = scope1.serviceProvider.getService(interface1Type)
	// 	@Expect(objectOption_1.isSome())
	// 	let interface1Option_1 = objectOption_1.getOrThrow() as Interface1
	// 	@Expect(interface1Option_1.isSome())
	// 	let interface1_1 = interface1Option_1.getOrThrow()
	// 	@Expect(interface1_1.toString() == "Class1")
		
	// 	let interface1Option_2 = scope1.serviceProvider.getRequiredService(interface1Type) as Interface1
	// 	@Expect(interface1Option_2.isSome())
	// 	let interface1_2 = interface1Option_2.getOrThrow()
	// 	@Expect(interface1_2.toString() == "Class1")
		
	// 	let interface1Option_3 = scope2.serviceProvider.getRequiredService(interface1Type) as Interface1
	// 	@Expect(interface1Option_3.isSome())
	// 	let interface1_3 = interface1Option_3.getOrThrow()
	// 	@Expect(interface1_3.toString() == "Class1")

	// 	@Expect(refEq((interface1_1 as Object).getOrThrow(), (interface1_2 as Object).getOrThrow()))
	// 	@Expect(!refEq((interface1_2 as Object).getOrThrow(), (interface1_3 as Object).getOrThrow()))

	// 	scope1.close()
	// 	scope2.close()

	// 	@Expect(provider.getService(class1Type).isNone())
	// 	@ExpectThrows[InvalidOperationException](provider.getRequiredService(class1Type))
	// }

	// @TestCase
	// func scopeRelatedObjectInject() {
	// 	let interface1Type = TypeInfo.of<Interface1>()
	// 	let class1Type = TypeInfo.of<Class1>()
	// 	let interface2Type = TypeInfo.of<Interface2>()
	// 	let class2Type = TypeInfo.of<Class2>()
	// 	let interface3Type = TypeInfo.of<Interface3>()
	// 	let class3Type = TypeInfo.of<Class3>()

	// 	let services = ServiceCollection()
	// 	services.addScoped(interface1Type, class1Type)
	// 	services.addScoped(interface2Type, class2Type)
	// 	services.addScoped(interface3Type, class3Type)
	// 	let provider = services.buildServiceProvider()
	// 	let scopeFactory = IServiceProvider.getRequiredService1<IServiceScopeFactory>(provider)
	// 	let scope1 = scopeFactory.createScope()
	// 	let scope2 = scopeFactory.createScope()
		
	// 	let objectOption_1 = scope1.serviceProvider.getService(interface3Type)
	// 	@Expect(objectOption_1.isSome())
	// 	let interface3Option_1 = objectOption_1.getOrThrow() as Interface3
	// 	@Expect(interface3Option_1.isSome())
	// 	let interface3_1 = interface3Option_1.getOrThrow()
	// 	@Expect(interface3_1.toString() == "Class3(Class1, Class2(Class1))")
		
	// 	let interface3Option_2 = scope1.serviceProvider.getRequiredService(interface3Type) as Interface3
	// 	@Expect(interface3Option_2.isSome())
	// 	let interface3_2 = interface3Option_2.getOrThrow()
	// 	@Expect(interface3_2.toString() == "Class3(Class1, Class2(Class1))")
		
	// 	let interface3Option_3 = scope2.serviceProvider.getRequiredService(interface3Type) as Interface3
	// 	@Expect(interface3Option_3.isSome())
	// 	let interface3_3 = interface3Option_3.getOrThrow()
	// 	@Expect(interface3_3.toString() == "Class3(Class1, Class2(Class1))")

	// 	@Expect(refEq((interface3_1 as Object).getOrThrow(), (interface3_2 as Object).getOrThrow()))
	// 	@Expect(!refEq((interface3_2 as Object).getOrThrow(), (interface3_3 as Object).getOrThrow()))

	// 	scope1.close()
	// 	scope2.close()

	// 	@Expect(provider.getService(class1Type).isNone())
	// 	@Expect(provider.getService(class2Type).isNone())
	// 	@Expect(provider.getService(class3Type).isNone())
	// 	@ExpectThrows[InvalidOperationException](provider.getRequiredService(class1Type))
	// 	@ExpectThrows[InvalidOperationException](provider.getRequiredService(class2Type))
	// 	@ExpectThrows[InvalidOperationException](provider.getRequiredService(class3Type))
	// }
}
