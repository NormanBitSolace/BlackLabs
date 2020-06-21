import UIKit

public extension URL {

    init(_ string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("App assumes '\(string)' is a valid URL.")
        }
        self = url
    }

    init(_ string: String) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("App assumes '\(string)' is a valid URL.")
        }
        self = url
    }

    //  let url = URL(base, ("practitioners",1), ("pets",1))
    init(_ base: String, _ pathPair: (path: String, id: Int?)...) {
        var uri = base
        for pair in pathPair {
            uri += "/\(pair.path)"
            if let id = pair.id {
                uri += "/\(id)"
            }
        }
        self.init(uri)
    }

    func getModel<T: Codable>(type: T.Type, completion: @escaping (T?) -> Void) {
        self.getData { data in
            completion(data?.decode())
        }
    }

    func postNoBody(completion: (() -> Void)?) {
        postData(data:nil) { _ in
            completion?()
        }
    }

    func postModel<T: Codable>(_ model: T, completion: @escaping (T?) -> Void) {
        guard let data = model.encode() else { return completion(nil) }
        postData(data: data) { result in
            if let o: T = result.decode() {
                completion(o)
            } else {
                completion(nil)
            }
        }
    }

    /// Posts a data transfer object and gets a model back
    func postModelDTO<T: Codable, R: Codable>(_ model: T, returnType: R.Type, completion: @escaping (R?) -> Void) {
        guard let data = model.encode() else { return completion(nil) }
        postData(data: data) { result in
            if let o: R = result.decode() {
                completion(o)
            } else {
                completion(nil)
            }
        }
    }

    func getData(completion: @escaping (Data?) -> Void) {
        let req = URLRequest.createGet(url: self)
        URLSession.shared.runTask(with: req) { result in
                switch result {
                case .success(let data):
                    completion(data)
                case .failure(_):
                    completion(nil) // eating the error message
                }
        }
    }

    func delete(completion: @escaping () -> Void) {
        let req = URLRequest.createDelete(url: self)
        URLSession.shared.runTask(with: req) { _ in completion() }
    }

    func getImage(completion: @escaping (UIImage?) -> Void) {
        self.getData { data in
            DispatchQueue.main.async {
                if let data = data,
                let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }

    static func open(_ urlStr: String) {
        if let url = URL(string: urlStr) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    func putData(data: Data, completion: @escaping (Result<Data?, DataTaskError>) -> Void) {
        let req = URLRequest.createPut(url: self, data: data)
        URLSession.shared.runTask(with: req) { result in completion(result) }
    }

    func postData(data: Data? = nil, completion: @escaping (Result<Data?, DataTaskError>) -> Void) {
        let req = URLRequest.createPost(url: self, data: data)
        URLSession.shared.runTask(with: req) { result in completion(result) }
    }
}

public extension Array where Iterator.Element == URL {
    /// Does a get on each URL and calls the completion when all calls have returned.
    func get(completion: @escaping ([Data]) -> Void) {
        let group = DispatchGroup()
        var dataArray = [Data]()
        self.forEach { url in
            group.enter()
            url.getData { data in
                if let data = data {
                    dataArray.append(data)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) { [] in
            completion(dataArray)
        }
    }

}
