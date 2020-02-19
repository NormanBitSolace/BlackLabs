import Foundation

public extension Array {
    mutating func append(ifNotNil element: Element?) {
        if let element = element {
            self.append(element)
        }
    }
}

public extension Array where Element: Hashable {
    var histogram: [Element: Int] {
        return self.reduce(into: [:]) { counts, elem in counts[elem, default: 0] += 1 }
    }
}

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

public extension Sequence where Element == String {

    /// Remove empty lines and lines containing empty quotes.
    var removeEmptyLines: [String]  {
        return self.filter { $0.count > 0 }.filter { !$0.isEmpty } // remove lines with empty quotes
    }
}

public extension Collection {

    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array {

    /**
         Shifts and wraps an array, forwards and backwards. Thanks to Imanou Petit on StackOverflow.

    Usage:

         let array = Array(1...10)

         let newArray = array.shift(withDistance: 3)

         print(newArray) // prints: [4, 5, 6, 7, 8, 9, 10, 1, 2, 3]


         var array = Array(1...10)

         array.shiftInPlace(withDistance: -2)

         print(array) // prints: [9, 10, 1, 2, 3, 4, 5, 6, 7, 8]


         let array = Array(1...10)

         let newArray = array.shift(withDistance: 30)

         print(newArray) // prints: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


         let array = Array(1...10)

         let newArray = array.shift(withDistance: 0)

         print(newArray) // prints: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


         var array = Array(1...10)

         array.shiftInPlace()

         print(array) // prints: [2, 3, 4, 5, 6, 7, 8, 9, 10, 1]


         var array = [Int]()

         array.shiftInPlace(withDistance: -2)

         print(array) // prints: []
     */
    func shift(withDistance distance: Int = 1) -> Array<Element> {
        let offsetIndex = distance >= 0 ?
            self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
            self.index(endIndex, offsetBy: distance, limitedBy: startIndex)

        guard let index = offsetIndex else { return self }
        return Array(self[index ..< endIndex] + self[startIndex ..< index])
    }

    mutating func shiftInPlace(withDistance distance: Int = 1) {
        self = shift(withDistance: distance)
    }

}

public struct Array2D<T> {
    public let rows: Int
    public let cols: Int
    var contents: [T]

    public init(numRows: Int, numCols: Int, defaultValue: T) {
        self.rows = numRows
        self.cols = numCols
        contents = Array(repeating: defaultValue, count: numRows*numCols)
    }

    public subscript(row: Int, col: Int) -> T {
        get {
            return contents[row*cols+col]
        }
        set {
            contents[row*cols+col] = newValue
        }
    }
}
