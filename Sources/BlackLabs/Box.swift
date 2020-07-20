import Foundation

//  https://www.hackingwithswift.com/plus/intermediate-swift/the-ultimate-box-type

final class Box<Type> {
    var value: Type

    init(_ value: Type) {
        self.value = value
    }
}

extension Box: CustomStringConvertible where Type: CustomStringConvertible {
    var description: String {
        value.description
    }
}

extension Box: Equatable where Type: Equatable {
    static func ==(lhs: Box, rhs: Box) -> Bool {
        lhs.value == rhs.value
    }
}

extension Box: Comparable where Type: Comparable {
    static func <(lhs: Box, rhs: Box) -> Bool {
        lhs.value < rhs.value
    }
}

extension Box: Hashable where Type: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

@available(iOS 13, *)
extension Box: Identifiable where Type: Identifiable {
    var id: Type.ID { value.id }
}
