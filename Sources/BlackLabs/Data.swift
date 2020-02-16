import UIKit

public extension Data {

    var asString: String { return String(decoding: self, as: UTF8.self) }

    func decode<T: Codable>() -> T? {
        do {
            let decoder = JSONDecoder()
            if #available(iOS 10.0, *) {
                decoder.dateDecodingStrategy = .iso8601
            }
            let resource = try decoder.decode(T.self, from: self)
            return resource

        } catch {
            print(self.asString)
            print(error.localizedDescription)
        }
        return nil
    }
}
