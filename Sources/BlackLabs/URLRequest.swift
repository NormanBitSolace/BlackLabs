import Foundation

//public extension URLResponse {
//    var statusCode: Int? {
//        if let httpResp = self as? HTTPURLResponse {
//            return httpResp.statusCode
//        }
//        return nil
//    }
//}

public extension URLRequest {
    /** Describes `URLReqest` METHOD , URL and headers respectively,

     Example output:
       POST
       https://my-json-server.typicode.com/nbasham/pet_database/pets
       headers: ["Content-Type": "application/json"]
 */
    var info: String {
        let headers = self.allHTTPHeaderFields?.description ?? ""
        let body = httpBody?.asString.prefix(100) ?? "no body"
        return ("\n\(self.httpMethod ?? "method unspecified") \n\(self.url?.absoluteString ?? "nil URL")\nheaders: \(headers)\nbody: \(body)")
    }

    static func createGet(url: URL) -> URLRequest {
        var req = URLRequest(url: url)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }

    static func createPost(url: URL, data: Data?) -> URLRequest {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.httpBody = data
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }

    static func createPut(url: URL, data: Data) -> URLRequest {
        var req = URLRequest(url: url)
        req.httpMethod = "PUT"
        req.httpBody = data
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }

    static func createDelete(url: URL) -> URLRequest {
        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }
}
