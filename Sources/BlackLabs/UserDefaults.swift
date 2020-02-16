import Foundation

public extension UserDefaults {

    static func get<T: Codable>(forKey key: String, defaultValue: T) -> T {
        let a: T? = UserDefaults.get(forKey: key)
        return a ?? defaultValue
    }
    static func get<T: Codable>(forKey key: String) -> T? {
        let s = UserDefaults.standard.object(forKey: key) as? String
        let a: T? = s?.data(using: .utf8)?.decode()
        return a
    }
    static func set(_ o: Codable, forKey key: String) {
        if let s = o.encode()?.asString {
            UserDefaults.standard.set(s, forKey: key)
        }
    }
    static func setOnce(_ value: Any, forKey key: String) {
        guard UserDefaults.standard.object(forKey: key) == nil else { return }
        UserDefaults.standard.set(value, forKey: key)
    }
}

//  old school
public extension UserDefaults {

    static func isUndefined(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) == nil
    }

    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

    static func isUndefinedThenDefine(key: String) -> Bool {
        let b = isUndefined(key: key)
        if b {
            UserDefaults.standard.set(Date(), forKey: key)
            UserDefaults.standard.synchronize()
        }
        return b
    }

    static func getb(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }

    static func geti(_ key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }

    static func getui(_ key: String) -> UInt {
        return UInt(UserDefaults.geti(key))
    }

    static func geto(_ key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }

    static func remove(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }

    static func save(_ value: Any, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

}
