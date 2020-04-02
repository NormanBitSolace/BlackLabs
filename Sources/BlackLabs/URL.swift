import UIKit

public extension URL {

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

    func putData(data: Data, completion: @escaping (Result<Data?, URLSessionError>) -> Void) {
        let req = URLRequest.createPut(url: self, data: data)
        URLSession.shared.runTask(with: req) { result in completion(result) }
    }

    func postData(data: Data, completion: @escaping (Result<Data?, URLSessionError>) -> Void) {
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
