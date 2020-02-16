import Foundation

open class DataService<Model: Codable>: RestHelper {
    let base: String
    let path: String

    public init(base: String, path: String) {
        self.base = base
        self.path = path
    }

    public func get(id: Int, completion: @escaping (Model?) -> Void) {
        self.get(type: Model.self, url: URL(base, (path, id))) { o in
            completion(o)
        }
    }

    public func get(completion: @escaping ([Model]?) -> Void) {
        self.get(type: [Model].self, url: URL(base + "/\(path)")) { o in
            completion(o)
        }
    }

    public func get(ids: [Int], completion: @escaping ([Model]?) -> Void) {
        let urls = ids.map { URL(base, ("\(path)", $0)) }
        urls.get { data in
            let o: [Model] = data.compactMap { $0.decode() }
            completion(o)
        }
    }

    public func create(model: Model, completion: @escaping (Model?) -> Void) {
        self.post(model: model, url: URL(base + "/\(path)")) { o in
            completion(o)
        }
    }

    /// Prefer `create` methos the `add  method is for legacy support.
    public func add(model: Model, completion: @escaping (Model?) -> Void) {
        self.create(model: model, completion: completion)
    }

    /// TODO iOS 13 / Swift 5.1 Ensure `Model` conforms to `Identifiable` inorder to remove` id` parameter, and use `model.id` instead.
    public func update(id: Int, model: Model, completion: @escaping (Model?) -> Void) {
        self.put(model: model, url: URL(base, (path, id))) { o in
            completion(o)
        }
    }

    public func delete(id: Int, completion: @escaping () -> Void) {
        self.delete(url: URL(base, (path, id))) { completion() }
    }
}
