import UIKit

public extension String {
    
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive == false {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    
    func toClass() -> AnyClass? {
        let nameSpace = Bundle.main.appNameSpace.replacingOccurrences(of: " ", with: "_")
        return NSClassFromString("\(nameSpace).\(self)")
    }
    
    func toArray() -> [String] {
        return self.compactMap { String($0) }
    }

    var toLines: [String] {
        let lines = self.components(separatedBy: CharacterSet.newlines).map { $0.trim }
        return lines
    }
    /// Converts a string to a `Dictionary` assuming key and value are separated by commas.
    var toDictionary: [String: String]  {
        return self.toDictionary()
    }
    func toDictionary(delimiter: String = "\t") -> [String: String]  {
        return self.toLines.toDictionary(delimiter: delimiter)
    }
    var trim: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

//let a = [1,2,3,4]
//let sa = CsvString.fromIntArray(a)
//CsvString(sa).toIntArray()
open class CsvString {
    let s: String?
    
    public init(_ s: String?) {
        self.s = s
    }
    public func toIntArray()->[Int] {
        guard let s = s else {
            return [Int]()
        }
        return s.components(separatedBy: ",").compactMap { Int($0)! }
    }
    public static func fromIntArray(_ a: [Int]?) -> String? {
        return a?.map(String.init).joined(separator: ",")
    }
}
