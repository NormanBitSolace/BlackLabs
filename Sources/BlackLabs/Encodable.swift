import Foundation

public extension Encodable {

    var jsonString: String? {
        return encode(isPretty: true)?.asString
    }
    func encode(isPretty: Bool = false) -> Data? {
        do {
            let encoder = JSONEncoder()
            if #available(iOS 10.0, *) {
                encoder.dateEncodingStrategy = .iso8601
            }
            if isPretty {
                encoder.outputFormatting = .prettyPrinted
            }
            let data = try encoder.encode(self)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
