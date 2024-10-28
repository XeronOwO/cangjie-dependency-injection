package dependency_inject

import std.collection.*
import std.reflect.*

interface IFoo <: ToString {
}

class Foo <: Object & IFoo {
	public override func toString(): String {
		"Foo"
	}
}

func get(): ?Any {
	let fooType = (TypeInfo.of<Foo>() as ClassTypeInfo).getOrThrow() // ok
	let fooConstructor = fooType.constructors.iterator().first().getOrThrow() // ok
	let objInstance = (fooConstructor.apply([]) as Object).getOrThrow() // ok
	return objInstance
}

main(): Unit {
	let objInstance = (get().getOrThrow() as Object).getOrThrow()
	// let fooInstance = (objInstance as Foo).getOrThrow() // ok
	// println(fooInstance) // ok
	let ifooInstance = (objInstance as IFoo).getOrThrow() // ok
	println(ifooInstance) // err: itable is nullptr

	let services = ServiceCollection()
	ServiceCollection.addTransient2<IFoo, Foo>(services)
	let provider = ServiceProvider(services, ServiceProviderOptions())
	let ifoo = IServiceProvider.getService1<IFoo>(provider)
	if (ifoo.isNone()) {
		println("ifoo is None")
	} else {
		println(ifoo.getOrThrow().toString())
	}
}
