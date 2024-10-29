<div align="center">

# Cangjie Dependency Injection

**&gt; English &lt;** | [简体中文](README_zh.md)  

</div>

## Introduction

Dependency injection module for Cangjie programming language, inspired by  [Microsoft.Extensions.DependencyInjection](https://github.com/dotnet/runtime/tree/main/src/libraries/Microsoft.Extensions.DependencyInjection) .  

## Sample

```cangjie
package app

import dependency_inject.*
import std.collection.*
import std.reflect.*
import std.unittest.*

interface I1 <: ToString {}

class C1 <: I1 {
	public func toString(): String { "C1" }
}

interface I2 <: ToString {}

class C2 <: I2 {
	private let _i1: I1
	public init(i1 : I1) {
		_i1 = i1
	}
	
	public func toString(): String { "C2(${_i1})" }
}

interface I3 <: ToString {}

class C3 <: I3 {
	private let _i1: I1
	private let _i2: I2
	public init(i1 : I1, i2 : I2) {
		_i1 = i1
		_i2 = i2
	}
	
	public func toString(): String { "C3(${_i1}, ${_i2})" }
}

@Test
main(): Unit {
	let services = ServiceCollection()
	ServiceCollection.addTransient2<I1, C1>(services)
	ServiceCollection.addTransient2<I2, C2>(services)
	ServiceCollection.addTransient2<I3, C3>(services)
	let provider = ServiceProvider(services, ServiceProviderOptions())
	let i3 = IServiceProvider.getRequiredService1<I3>(provider)
	@Expect(i3.toString() == "C3(C1, C2(C1))")
}

```

## Note

Because Cangjie's reflection system is not yet complete, it can't reflect open generic types and enumeration types, such as `Array<>` and `Option<T>`, so there are some limitations on its use.  
Currently, we only support simple Interface-Implementation relationships, but not generic types such as `Iterable<T>`.  

## Special Thanks

Special thanks to the Cangjie Development Team and the group members of the Cangjie HarmonyOS Application Development Exchange Group for their help.
