import Foundation

extension Data {
    var utf8String: String {
        String(decoding: self, as: UTF8.self)
    }
}

public extension JSONEncoder {
    static func encodeString<T: Encodable>(_ value: T, options opt: JSONSerialization.ReadingOptions = []) -> String {
        let data = try? JSONEncoder().encode(value)
        
        return data?.utf8String ?? ""
    }
    
    static func encodeData<T: Encodable>(_ value: T, options opt: JSONSerialization.ReadingOptions = []) -> Data {
        let data = try? JSONEncoder().encode(value)
        
        return data ?? Data()
    }
}

extension JSONDecoder {
    static func decode<T: Decodable>(_ type: T.Type, from: String) -> T? {
        try? JSONDecoder().decode(type, from: from.utf8Encoded)
    }
    
    static func decode<T: Decodable>(_ type: T.Type, from: Data) -> T? {
        try? JSONDecoder().decode(type, from: from)
    }
    
    static func unsafeDecode<T: Decodable>(_ type: T.Type, from: String) throws -> T {
        try JSONDecoder().decode(type, from: from.utf8Encoded)
    }
    
    static func unsafeDecode<T: Decodable>(_ type: T.Type, from: Data) throws -> T {
        try JSONDecoder().decode(type, from: from)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Int {
    var formattedTime: String {
        var left = self
        if left < 60 {
            return "\(left) sec"
        } else if left < 3600 {
            let minutes = left / 60
            left -= minutes * 60
            return left > 0 ? String(format: "%d min %d sec", minutes, left) : String(format: "%d min", minutes)
        } else if left < 86400 {
            let hours = left / 3600
            left -= hours * 3600
            let minutes = left / 60
            return minutes > 0 ? String(format: "%d hr %d min", hours, minutes) : String(format: "%d hr", hours)
        } else {
            let hours = left / 3600
            return String(format: "%d hr", hours)
        }
    }
}
