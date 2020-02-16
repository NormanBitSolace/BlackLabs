import UIKit

public extension CGSize {

    func inset(by inset: UIOffset) -> CGSize { return CGSize(width: width - inset.horizontal, height: height - inset.vertical)}

    func contains(size: CGSize) -> Bool { return width >= size.width && height >= size.height }
}

public extension Array where Element == CGRect {
    var union: CGRect {
        return self.map { $0 }.reduce(.zero) { all, r in all.union(r) }
    }

    mutating func add(_ x: Int, _ y: Int, _ w: Int, _ h: Int) {
        self.append(CGRect(x: x, y: y, width: w, height: h))
    }
}

public extension Array where Element == CGRect? {
    var union: CGRect {
        return self.compactMap { $0 }.reduce(.zero) { all, r in all.union(r) }
    }
}


public extension Array where Element == CGPoint {
    mutating func add(_ x: Int, _ y: Int) {
        self.append(CGPoint(x: x, y: y))
    }
}


public extension CGRect {
    var center: CGPoint {
        let center = CGPoint(x: origin.x + size.width / 2, y: origin.y +  size.height / 2)
        return center
    }
    func centerUnder(rect: CGRect) -> CGRect {
        return CGRect(x: rect.midX - (size.width / 2.0), y: rect.maxY, width: size.width, height: size.height)
    }
    func centerAbove(rect: CGRect) -> CGRect {
        return CGRect(x: rect.midX - (size.width / 2.0), y: rect.minY - size.height, width: size.width, height: size.height)
    }
    func centerOnRight(rect: CGRect) -> CGRect {
        return CGRect(x: rect.maxX, y: rect.midY - size.height/2, width: size.width, height: size.height)
    }
    func centerOnLeft(rect: CGRect) -> CGRect {
        return CGRect(x: rect.minX - size.width, y: rect.midY - size.height/2, width: size.width, height: size.height)
    }
    func isOffLeft(_ container: CGRect) -> Bool {
        return minX < container.minX
    }
    func isOffRight(_ container: CGRect) -> Bool {
        return maxX > container.maxX
    }
    func isOffBottom(_ container: CGRect) -> Bool {
        return maxY > container.maxY
    }
    static func squareFitsInCircle(withDiameter diameter: CGFloat) -> CGRect {
        // http://mathcentral.uregina.ca/QQ/database/QQ.09.04/bob1.html
        let side = ((diameter * diameter) / 2).squareRoot()
        return CGRect(origin: .zero, size: CGSize(width: side, height: side))
    }
}
