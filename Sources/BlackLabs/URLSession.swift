import Foundation

public extension URLSession {

    private static let loggingKey = "___URLSessionLoggingKey___"

    func log(_ on: Bool = true) {
        UserDefaults.standard.set(on, forKey: URLSession.loggingKey)
    }

    /// Prints `URLSessionDataTask` request info
    func runTask(with request: URLRequest, completion: @escaping (Result<Data?, DataTaskError>) -> Void) {
        let logging = UserDefaults.standard.bool(forKey: URLSession.loggingKey)
        if logging { print(request.info) }
        let task = URLSession.shared.dataTask(with: request) { data, resp, err in
            if let resp = resp as? HTTPURLResponse {
                switch resp.statusCode {
                case 200 ..< 300:
                    if logging { print("Success \(data?.asString.prefix(100) ?? "nil"))") }
                    completion(.success(data))
                default:
                    let error: DataTaskError = .httpStatusResponse(resp.statusCode)
                    if logging { print(error) }
                    return completion(.failure(error))
                }
            } else if let err = err {
                let error: DataTaskError = .response(err)
                if logging { print(error) }
                return completion(.failure(error))
            }
        }
        task.resume()
    }}
