import Foundation

public enum URLSessionError: Error {
    /// HTTP response error e.g. 400. All responses are greater than or equal to 400 (redirects, success, etc. are not considered errors).
    case httpStatus(Int)
    /// `URLSession.dataTask` returned an error.
    case dataTask(Error)
}

extension URLSessionError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .httpStatus(let statusCode):
            let message = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            return message
        case .dataTask(let err):
            return err.localizedDescription
        }
    }


}
