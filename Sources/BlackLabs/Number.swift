import UIKit

public extension Int {
    var f: CGFloat { return CGFloat(self) }
    var d: Double { return Double(self) }
    var s: String { return "\(self)" }

    /// 2.format("03") yeilds 002
    func format(_ f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}

public extension CGFloat {
    var i: Int { return Int(self) }
    var d: Double { return Double(self) }
    var s: String { return "\(self)" }

    /// let cgf: CGFloat = 8; cgf.format("3") yeilds "8.000"
    func format(_ f: String) -> String {
        return String(format: "%.\(f)f", self)
    }
}

public extension Double {
    var i: Int { return Int(self) }
    var f: CGFloat { return CGFloat(self) }
    var s: String { return "\(self)" }

    /// Double.pi.format("3") yeilds "3.142"
    func format(_ f: String) -> String {
        return String(format: "%.\(f)f", self)
    }
}

public extension Int {

    func mapFromZero<T>(_ transform: (Int) -> T) -> [T] {
        return (0..<self).map { transform($0) }
    }

    var spellOut: String? {
        let numberValue = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter.string(from: numberValue)
    }

    func times(_ f: () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }

    /// 96.timerValue, yeilds "1:36"
    var timerValue: String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        let timeStr = hours == 0 ? "\(minutes):\(String(format: "%02d", seconds))" : "\(hours):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        return timeStr
    }

    var withCommas: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
