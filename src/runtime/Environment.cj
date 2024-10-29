package dependency_injection.runtime

public class Environment {
	@When[os == "Windows"]
	public static const newLineConst: String = "\r\n"
	@When[os == "HarmonyOS"]
	public static const newLineConst: String = "\n"
	@When[os == "Linux"]
	public static const newLineConst: String = "\n"
	@When[os == "macOS"]
	public static const newLineConst: String = "\r"

	public static prop newLine: String {
		get() { newLineConst }
	}
}
