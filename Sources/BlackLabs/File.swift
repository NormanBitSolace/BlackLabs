import Foundation

public extension URL {

    init(localFile name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: nil) else {
            preconditionFailure("Expected local file: \(name)")
        }
        self.init(fileURLWithPath: path)
    }
}

public extension Data {

    init(localFile name: String) {
        let url = URL(localFile: name)
        do {
            try self.init(contentsOf: url)
        } catch {
            preconditionFailure("Expected local file named: \(name).")
        }
    }

    static func parse<T>(localFile name: String, _ callback: (String)->T) -> T {
        let data = Data(localFile: name)
        let fileContents = String(decoding: data, as: UTF8.self)
        let result = callback(fileContents)
        return result
    }

    static func fromLocalFile(_ localFile: String) -> String? {
        let data = Data(localFile: localFile)
        let fileContents = String(decoding: data, as: UTF8.self)
        return fileContents
    }

    static func lines(localFile name: String) -> [String]? {
        let lines: [String]? = Data.parse(localFile: name) { str in
            let lines = str.components(separatedBy: CharacterSet.newlines).filter { $0.count > 0 }
            return lines.compactMap { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
        }
        return lines
    }
}

public protocol IOSDirectoryFile {
    static var dirSelector: FileManager.SearchPathDirectory { get }
}

public extension IOSDirectoryFile {

    static var url: URL {
        return FileManager.default.urls(for: dirSelector, in: .userDomainMask)[0]
    }

    static func path(_ fileName: String) -> String {
        return url.appendingPathComponent(fileName).path
    }

    static func load(_ fileName: String) -> Any? {
        let fullPath = path(fileName)
        return NSKeyedUnarchiver.unarchiveObject(withFile: fullPath)
    }

    static func exists(_ fileName: String) -> Bool {
        let fullPath = path(fileName)
        let b = FileManager.default.fileExists(atPath: fullPath)
        return b
    }

    static func save(_ object: Any, fileName: String) {
        // may fail because it may not exist in sandbox, so check existence and create if necessary
        if FileManager.default.fileExists(atPath: url.absoluteString) == false {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        let fullPath = path(fileName)
        let succeeded = NSKeyedArchiver.archiveRootObject(object, toFile: fullPath)
        if succeeded == false {
            print("Failed saving \(fullPath)")
        }
    }

    static func remove(_ fileName: String) {
        let fullPath = path(fileName)
        try? FileManager.default.removeItem(atPath: fullPath)
    }
}

/// Example usage:
/// - AppSupportFile.load("name.txt")
/// - AppSupportFile.save(fileContents, fileName: "name.txt")
/// - AppSupportFile.remove("name.txt")
public class AppSupportFile: IOSDirectoryFile {
    public static var dirSelector: FileManager.SearchPathDirectory { return .applicationSupportDirectory }
}

/// Example usage:
/// - DocumentsFile.load("name.txt")
/// - DocumentsFile.save(fileContents, fileName: "name.txt")
/// - DocumentsFile.remove("name.txt")
public class DocumentsFile: IOSDirectoryFile {
    public static var dirSelector: FileManager.SearchPathDirectory { return .documentDirectory }
}
