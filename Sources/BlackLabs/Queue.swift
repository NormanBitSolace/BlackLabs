import Foundation

public struct Queue<T> {
    private var contents = [T]()
    public var count: Int { return contents.count }
    public var isEmpty: Bool { return contents.isEmpty }
    public var front: T? { return contents.first }

    public mutating func enqueue(_ element: T) {
        contents.append(element)
    }

    public mutating func dequeue() -> T? {
        return contents.remove(at: 0)
    }
}
