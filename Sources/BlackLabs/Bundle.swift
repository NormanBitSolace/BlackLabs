import Foundation

public extension Bundle {

    subscript(key: String) -> String { valueFromInfoPList(key) }

    func parseCSV<T>(key: String, _ callback: (String)->T) -> [T] {
        let s = self[key]
        let a = s.components(separatedBy: ",")
        return a.compactMap { callback($0) }
    }

    func valueFromInfoPList(_ key: String) -> String {
        if let value = infoDictionary?[key] as? String {
            return value
        }
        fatalError("infoDictionary doesn't contain key \(key)")
    }

    /// Gets the app's name.
    var appName: String { valueFromInfoPList("CFBundleName") }
    /// Gets the app's name and full version e.g. Cryptogram 1.0.23
    var appNameAndVersion: String { "\(appName) \(fullVersion)" }
    /// Gets the version.buildNumber
    var fullVersion: String { "\(version).\(buildNumber)" }
    /// Gets the short version. (Example: "1.0")
    var version: String { valueFromInfoPList("CFBundleShortVersionString") }
    /// Gets the build number. (Example: "23")
    var buildNumber: String { valueFromInfoPList("CFBundleVersion") }
    /// Gets the app's namesapce e.g. DailyPuzzles
    var appNameSpace: String { valueFromInfoPList("CFBundleExecutable") }
}

//
//  Bundle-Decodable.swift
//  FilteringListExample
//
//  Created by Paul Hudson on 06/06/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//
extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
