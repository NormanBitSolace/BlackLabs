import Foundation

public extension Result where Success == Data? {
    func decode<T: Codable>() -> T? {
        if case let .success(data) = self {
            guard let d = data else { return nil }
            if let model: T = d.decode() {
                return model
            }
        }
        return nil
    }
}
