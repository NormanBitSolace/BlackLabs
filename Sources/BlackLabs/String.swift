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
    /// If a string begins with a key  and a value separated by a tab, this will return a key value pair.
    var keyValue: (String, String)? {
        let parts = self.components(separatedBy: "\t")
        if parts.count >= 2 {
            let key = parts[0].trim
            /// It is possible that the value contents include a tab so they are rejoined vs. using parts[1].trim
            let value = (parts[1..<parts.count]).joined(separator: "\t").trim
            return (key, value)
        }
        return nil
    }

    static let alphabet: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    func substring(start: Int, length: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
//        guard self.startIndex > startIndex else { return nil }
        let endIndex = self.index(startIndex, offsetBy: length)
//        guard self.endIndex <= endIndex else { return nil }
        let range = startIndex..<endIndex
        return String(self[range])
    }

    var isLetter: Bool { return self[self.startIndex].isLetter }
    var isNumber: Bool { return self[self.startIndex].isNumber }
    var isWhitespace: Bool { return self[self.startIndex].isWhitespace }

    var longestWord: String? {
        if let longest = self.components(separatedBy: [" ", "-"]).max(by: { $1.count > $0.count }) {
            return longest
        }
        return nil
    }

    /// Removes accents above and below letters e.g. é.
    var withoutDiacritics: String { return self.folding(options: .diacriticInsensitive, locale: NSLocale.current) }

    func size(forFont font: UIFont) -> CGSize {
        let size: CGSize = self.size(withAttributes: [NSAttributedString.Key.font: font as Any])
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }

    func lastPosition(of c: Character) -> Int? {
        if let index = lastIndex(of: c) {
            return index.utf16Offset(in: self)
        }
        return nil
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
