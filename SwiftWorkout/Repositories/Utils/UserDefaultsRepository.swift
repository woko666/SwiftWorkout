import Foundation

protocol UserDefaultsRepository {
}

extension UserDefaultsRepository {
    func encodeJson<T: Codable>(_ key: String, value: T) {
        set(key, value: JSONEncoder.encodeString(value))
    }
    
    func decodeJson<T: Codable>(_ key: String, defaults: T) -> T {
        get(key).flatMap { JSONDecoder.decode(T.self, from: $0) } ?? defaults
    }
    
    func decodeJson<T: Codable>(_ key: String) -> T? {
        get(key).flatMap { JSONDecoder.decode(T.self, from: $0) }
    }
    
    func set(_ key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func get(_ key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }
}
