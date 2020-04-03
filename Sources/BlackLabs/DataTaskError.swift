import Foundation

public enum DataTaskError: Error {
    /// HTTP response error e.g. 400. All responses are greater than or equal to 400 (redirects, success, etc. are not considered errors).
    case httpStatusResponse(Int)
    /// `URLSession.dataTask` returned an error.
    case response(Error)

    public var asResult: Result<Data?, DataTaskError> {
        .failure(self)
    }
}

extension DataTaskError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .httpStatusResponse(let statusCode):
            let message = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            return message
        case .response(let err):
            return err.localizedDescription
        }
    }
}
