import Foundation

public extension Bundle {

    subscript(key: String) -> String { valueFromInfoPList(key) }

    func parseCSV<T>(key: String, _ callback: (String)->T) -> [T] {
        let s = self[key]
        let a = s.components(separatedBy: ",")
        return a.compactMap { callback($0) }
    }

    func valueFromInfoPList(_ key: String) -> String {
        if let value = infoDictionary?[key] as? String {
            return value
        }
        fatalError("infoDictionary doesn't contain key \(key)")
    }

    /// Gets the app's name.
    var appName: String { valueFromInfoPList("CFBundleName") }
    /// Gets the app's name and full version e.g. Cryptogram 1.0.23
    var appNameAndVersion: String { "\(appName) \(fullVersion)" }
    /// Gets the version.buildNumber
    var fullVersion: String { "\(version).\(buildNumber)" }
    /// Gets the short version. (Example: "1.0")
    var version: String { valueFromInfoPList("CFBundleShortVersionString") }
    /// Gets the build number. (Example: "23")
    var buildNumber: String { valueFromInfoPList("CFBundleVersion") }
    /// Gets the app's namesapce e.g. DailyPuzzles
    var appNameSpace: String { valueFromInfoPList("CFBundleExecutable") }
}
