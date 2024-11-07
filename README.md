<div align="center">

# Cangjie Dependency Injection

**&gt; English &lt;** | [简体中文](README_zh.md)  

</div>

## Introduction

Dependency injection module for Cangjie programming language, inspired by  [Microsoft.Extensions.DependencyInjection](https://github.com/dotnet/runtime/tree/main/src/libraries/Microsoft.Extensions.DependencyInjection) .  

## Sample

Note: Because Cangjie language lacks the features of interface extension for the time being, you can only call some extension functions through the original calling method, which is more troublesome. When Cangjie language is rich in features, it will be simpler.  

```cangjie
package app

import dependency_injection.*
import dependency_injection.abstractions.*
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

main(): Unit {
	let services = ServiceCollection()
	ServiceCollectionServiceExtensions.addTransient2<I1, C1>(services)
	ServiceCollectionServiceExtensions.addTransient2<I2, C2>(services)
	ServiceCollectionServiceExtensions.addTransient2<I3, C3>(services)
	let provider = ServiceCollectionContainerBuilderExtensions.buildServiceProvider(services)
	let i3 = ServiceProviderServiceExtensions.getRequiredService1<I3>(provider)
	println("Expect: C3(C1, C2(C1))")
	println("Actual: ${i3}")
}

```

## Note

Because Cangjie's reflection system is not yet complete, it can't reflect open generic types and enumeration types, such as `Array<>` and `Option<T>`, so there are some limitations on its use.  
Currently, we only support simple Interface-Implementation relationships, but not generic types such as `Iterable<T>`.  

## Special Thanks

Special thanks to the Cangjie Development Team and the group members of the Cangjie HarmonyOS Application Development Exchange Group for their help.
