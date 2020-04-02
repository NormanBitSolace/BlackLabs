import Foundation

public extension URLSession {

    private static let loggingKey = "___URLSessionLoggingKey___"

    func log(_ on: Bool = true) {
        UserDefaults.standard.set(on, forKey: URLSession.loggingKey)
    }

    /// Prints `URLSessionDataTask` request info
    func runTask(with request: URLRequest, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
        let logging = UserDefaults.standard.bool(forKey: URLSession.loggingKey)
        if logging { print(request.info) }
        let task = URLSession.shared.dataTask(with: request) { data, resp, err in
            guard err == nil else {
                let error: NetworkError = .dataTask(err!)
                if logging { print(error) }
                return completion(.failure(error))
            }
            if let statusCode = resp?.statusCode {
                guard statusCode < 400  else {
                    let error: NetworkError = .httpStatus(statusCode)
                    if logging { print(error) }
                    return completion(.failure(error))
                }
            }
            if logging { print("Success \(data?.asString.prefix(100) ?? "nil"))") }
            completion(.success(data))
        }
        task.resume()
    }
}
