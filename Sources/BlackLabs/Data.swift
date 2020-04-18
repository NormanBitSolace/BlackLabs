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

        //  Printing error.localizedDescription in Decodable catch blocks is misleading because it displays only a quite meaningless generic error message.
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        return nil
    }
}
