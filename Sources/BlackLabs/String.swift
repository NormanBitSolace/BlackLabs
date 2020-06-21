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
    func keyValue(delimiter: String = "\t") -> (String, String)? {
        let parts = self.components(separatedBy: delimiter)
        if parts.count >= 2 {
            let key = parts[0].trim
            /// It is possible that the value contents include a tab so they are rejoined vs. using parts[1].trim
            let value = (parts[1..<parts.count]).joined(separator: delimiter).trim
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

//  https://github.com/yichizhang/SwiftyStringScore
public extension String {

  func charAt(_ i: Int) -> Character {
    let index = self.index(self.startIndex, offsetBy: i)
    return self[index]
  }

  func charStrAt(_ i: Int) -> String {
    return String(charAt(i))
  }
}

public extension String {

  func score(word: String, fuzziness: Double? = 1) -> Double {

    // If the string is equal to the word, perfect match.
    if self == word {
      return 1
    }

    //if it's not a perfect match and is empty return 0
    if word.isEmpty || self.isEmpty {
      return 0
    }

    var runningScore = 0.0
    var charScore = 0.0
    var finalScore = 0.0

    let string = self
    let lString = string.lowercased()
    let strLength = string.count
    let lWord = word.lowercased()
    let wordLength = word.count

    var idxOf: String.Index!
    var startAt = lString.startIndex
    var fuzzies = 1.0
    var fuzzyFactor = 0.0
    var fuzzinessIsNil = true

    // Cache fuzzyFactor for speed increase
    if let fuzziness = fuzziness {
      fuzzyFactor = 1 - fuzziness
      fuzzinessIsNil = false
    }

    for i in 0 ..< wordLength {
      // Find next first case-insensitive match of word's i-th character.
      // The search in "string" begins at "startAt".

      if let range = lString.range(
        of: lWord.charStrAt(i),
        options: [.caseInsensitive, .diacriticInsensitive],
        range: startAt..<lString.endIndex,
        locale: nil
        ) {

        // start index of word's i-th character in string.
        idxOf = range.lowerBound

        if startAt == idxOf {
          // Consecutive letter & start-of-string Bonus
          charScore = 0.7
        }
        else {
          charScore = 0.1

          // Acronym Bonus
          // Weighing Logic: Typing the first character of an acronym is as if you
          // preceded it with two perfect character matches.
          if string[string.index(before: idxOf)] == " " {
            charScore += 0.8
          }
        }
      }
      else {
        // Character not found.
        if fuzzinessIsNil {
          // Fuzziness is nil. Return 0.
          return 0
        }
        else {
          fuzzies += fuzzyFactor
          continue
        }
      }

      // Same case bonus.
      if (string[idxOf] == word[word.index(word.startIndex, offsetBy: i)]) {
        charScore += 0.1
      }

      // Update scores and startAt position for next round of indexOf
      runningScore += charScore
      startAt = string.index(idxOf, offsetBy: 1)
    }

    // Reduce penalty for longer strings.
    finalScore = 0.5 * (runningScore / Double(strLength) + runningScore / Double(wordLength)) / fuzzies

    if (finalScore < 0.85) &&
      (lWord.charStrAt(0).compare(lString.charStrAt(0), options: .diacriticInsensitive) == .orderedSame) {
      finalScore += 0.15
    }

    return finalScore
  }
}

public extension String {
    static let stateDictionary: [String : String] = [
        "Alaska" : "AK",
        "Alabama" : "AL",
        "Arkansas" : "AR",
        "American Samoa" : "AS",
        "Arizona" : "AZ",
        "California" : "CA",
        "Colorado" : "CO",
        "Connecticut" : "CT",
        "District of Columbia" : "DC",
        "Delaware" : "DE",
        "Florida" : "FL",
        "Georgia" : "GA",
        "Guam" : "GU",
        "Hawaii" : "HI",
        "Iowa" : "IA",
        "Idaho" : "ID",
        "Illinois" : "IL",
        "Indiana" : "IN",
        "Kansas" : "KS",
        "Kentucky" : "KY",
        "Louisiana" : "LA",
        "Massachusetts" : "MA",
        "Maryland" : "MD",
        "Maine" : "ME",
        "Michigan" : "MI",
        "Minnesota" : "MN",
        "Missouri" : "MO",
        "Mississippi" : "MS",
        "Montana" : "MT",
        "North Carolina" : "NC",
        " North Dakota" : "ND",
        "Nebraska" : "NE",
        "New Hampshire" : "NH",
        "New Jersey" : "NJ",
        "New Mexico" : "NM",
        "Nevada" : "NV",
        "New York" : "NY",
        "Ohio" : "OH",
        "Oklahoma" : "OK",
        "Oregon" : "OR",
        "Pennsylvania" : "PA",
        "Puerto Rico" : "PR",
        "Rhode Island" : "RI",
        "South Carolina" : "SC",
        "South Dakota" : "SD",
        "Tennessee" : "TN",
        "Texas" : "TX",
        "Utah" : "UT",
        "Virginia" : "VA",
        "Virgin Islands" : "VI",
        "Vermont" : "VT",
        "Washington" : "WA",
        "Wisconsin" : "WI",
        "West Virginia" : "WV",
        "Wyoming" : "WY"
    ]
}
