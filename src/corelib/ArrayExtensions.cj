package dependency_injection.corelib

extend<T> Array<T> {
	public static func clear(array: Array<?T>, index: Int, length: Int) {
		for (i in index..length) {
			array[i] = None
		}
	}

	public static prop maxLength: Int {
		get() { 0X7FFFFFC7 }
	}
}
