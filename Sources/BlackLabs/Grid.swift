import UIKit

//  When Generics can be extended conform to Sequence, etc.
open class Grid<Element: Codable>: Codable {
    var a: [Element]
    public let numRows: Int
    public let numCols: Int
    public var count : Int { return numCols * numRows }
    
    public subscript(index: Int) -> Element {
        return value(index)
    }

    public init(numRows: Int, numCols: Int, initalValue: Element) {
        Grid.validateRange(numRows, min: 0, max: Int.max, valueDescription: "Grid numRows")
        Grid.validateRange(numCols, min: 0, max: Int.max, valueDescription: "Grid numCols")
        self.numRows = numRows
        self.numCols = numCols
        a = Array.init(repeating: initalValue, count: numCols * numRows)
    }

    public init(numRows: Int, numCols: Int, array: [Element]) {
        Grid.validateRange(numRows, min: 0, max: Int.max, valueDescription: "Grid numRows")
        Grid.validateRange(numCols, min: 0, max: Int.max, valueDescription: "Grid numCols")
        self.numRows = numRows
        self.numCols = numCols
        self.a = array
    }
    
    // TODO figure out why subclasses can't use this
//    public convenience init(numRows: Int, numCols: Int, initalValue: T) {
//        self.init(numRows: numRows, numCols: numCols, array: Array.init(repeating: initalValue, count: numCols * numRows))
//    }
    
    public var description: String {
        var s = "\("Grid")\n"
        
        //        for i in 0..<count {
        //            s += "\(i.format("2")) "
        //            if i % numCols == (numCols-1) {
        //                s += "\n"
        //            }
        //        }
        //        s += "\n"
        
        for i in 0..<count {
            let value = self.value(i)
            if value is Int {
                let intValue = value as! Int
                s += "\(intValue.format("2")) "
            } else if value is Double {
                let doubleValue = value as! Int
                s += "\(doubleValue.format("02")) "
            } else {
                s += "\(value)  "
            }
            if i % numCols == (numCols-1) {
                s += "\n"
            }
        }
        return s
    }
}


//  PUBLIC MUTATOR
public extension Grid {
    
    func setValue(newElement: Element, at index: Int) {
        valid(index)
        a[index] = newElement
    }
}

//  PUBLIC ACCESSORS
public extension Grid {
    
    func value(_ index: Int) -> Element {
        valid(index)
        return a[index]
    }
    
    func value(_ row: Int, _ col: Int) -> Element {
        valid(row: row)
        valid(col: col)
        return value(index(row, col))
    }
    
    func values() -> [Element] {
        return a
    }
    
    func values(inCol col: Int) -> [Element] {
        valid(col: col)
        return (0..<numRows).map { value($0, col) }
    }
    
    func values(inRow row: Int) -> [Element] {
        valid(row: row)
        return (0..<numCols).map { value(row, $0) }
    }
    
    func contains<Element: Equatable>(_ item: Element) -> Bool {
        return indexOf(item) != nil
    }
    
    func indexOf<Element: Equatable>(_ item: Element) -> Int? {
        // Swift's index(of:) doesn't work on array's with optional 
        return indexOf(item, in: a as! [Element])
    }
    
    func index(_ row: Int, _ col: Int) -> Int {
        valid(row: row)
        valid(col: col)
        return row * numCols + col
    }
    
    var indexes: [Int] {
        return Array(0..<count)
    }
    
    func indexes(forRow index: Int) -> [Int] {
        return indexes.compactMap { rowForIndex($0) == index ? $0 : nil }
    }
    
    func indexes(forCol index: Int) -> [Int] {
        return indexes.compactMap { colForIndex($0) == index ? $0 : nil }
    }
    
    func rowForIndex(_ index: Int) -> Int {
        valid(index)
        return index / numCols
    }
    
    func colForIndex(_ index: Int) -> Int {
        valid(index)
        return index % numCols
    }
}

fileprivate extension Grid {
    
    func indexOf<Element: Equatable>(_ item: Element, in array:[Element]) -> Int? {
        for i in 0..<array.count {
            if array[i] == item {
                return i
            }
        }
        return nil
    }
    
    func valid(row: Int) {
        Grid.validateRange(row, min: 0, max: numRows, valueDescription: "Grid row index")
    }
    
    func valid(col: Int) {
        Grid.validateRange(col, min: 0, max: numCols, valueDescription: "Grid col index")
    }
    
    func valid(_ index: Int) {
        Grid.validateRange(index, min: 0, max: count, valueDescription: "Grid index")
    }
    
    static func validateRange(_ value: Int, min : Int, max : Int, valueDescription: String) {
        if value < min || value >= max {
            fatalError("\(valueDescription) \(value) exceeds valid range of \(min)-\(max)")
        }
    }
}
