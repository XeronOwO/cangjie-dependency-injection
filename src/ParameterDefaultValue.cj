package dependency_injection

import std.reflect.*

internal class ParameterDefaultValue {
	public static func tryGetDefaultValue(parameter: ParameterInfo): (Bool, ?Any) {
		let parameterType = parameter.typeInfo

		var result = tryGetPrimitiveDefaultValue(parameterType)
		if (result[0]) {
			return result
		}

		// [Unsupported]
		// var result = tryGetOptionDefaultValue(parameterType)
		// if (result[0]) {
		// 	return result
		// }
		
		return (false, None)
	}

	private static func tryGetPrimitiveDefaultValue(typ: TypeInfo): (Bool, ?Any) {
		let primitiveTypeOption = typ as PrimitiveTypeInfo
		if (primitiveTypeOption.isNone()) {
			return (false, None)
		}

		let primitiveType = primitiveTypeOption.getOrThrow()
		if (primitiveType == TypeInfo.of<Unit>()) {
			return (true, ())
		}
		if (primitiveType == TypeInfo.of<Rune>()) {
			return (true, Rune(0))
		}
		if (primitiveType == TypeInfo.of<Bool>()) {
			return (true, false)
		}
		if (primitiveType == TypeInfo.of<Int8>()) {
			return (true, Int8(0))
		}
		if (primitiveType == TypeInfo.of<Int16>()) {
			return (true, Int16(0))
		}
		if (primitiveType == TypeInfo.of<Int32>()) {
			return (true, Int32(0))
		}
		if (primitiveType == TypeInfo.of<Int64>()) {
			return (true, Int64(0))
		}
		if (primitiveType == TypeInfo.of<IntNative>()) {
			return (true, IntNative(0))
		}
		if (primitiveType == TypeInfo.of<UInt8>()) {
			return (true, UInt8(0))
		}
		if (primitiveType == TypeInfo.of<UInt16>()) {
			return (true, UInt16(0))
		}
		if (primitiveType == TypeInfo.of<UInt32>()) {
			return (true, UInt32(0))
		}
		if (primitiveType == TypeInfo.of<UInt64>()) {
			return (true, UInt64(0))
		}
		if (primitiveType == TypeInfo.of<UIntNative>()) {
			return (true, UIntNative(0))
		}
		if (primitiveType == TypeInfo.of<Float16>()) {
			return (true, Float16(0))
		}
		if (primitiveType == TypeInfo.of<Float32>()) {
			return (true, Float32(0))
		}
		if (primitiveType == TypeInfo.of<Float64>()) {
			return (true, Float64(0))
		}
		
		return (false, None)
	}
}
