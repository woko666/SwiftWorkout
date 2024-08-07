import Foundation

protocol HttpApiCall {
    var path: String { get }
    var method: HttpMethod { get }
    var queryParams: [QueryParam]? { get }
    var headers: [String: String]? { get }
    var body: HttpBody? { get }
}

extension HttpApiCall {
    var queryParams: [QueryParam]? {
        nil
    }
    var headers: [String: String]? {
        nil
    }
    var body: HttpBody? {
        nil
    }
}

struct QueryParam: Equatable {
    var key: String
    var value: String
    
    init(_ key: String, _ value: String) {
        self.key = key
        self.value = value
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200..<300
}
    
enum HttpMethod: String {
    case get
    case post
}

extension HttpApiCall {
    func urlRequest(baseUrl: String) throws -> URLRequest {
        guard let urlBase = URL(string: baseUrl) else { throw HttpApiError.invalidUrl }
        let url = urlBase.appendingPathComponent(path)
        var request = URLRequest(url: url)
        
        if let params = queryParams, params.count > 0 {
            let encodedParams = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            if let queryUrl = URL(string: url.absoluteString + "?" + encodedParams) {
                request = URLRequest(url: queryUrl)
            } else if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
                if let url = components.url {
                    request = URLRequest(url: url)
                }
            }
        }
        
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        let bodyData = body
        
        if case .post = method, let data = bodyData?.body {
            request.httpBody = data
            if let additionalHeaders = bodyData?.additionalHeaders {
                request.allHTTPHeaderFields = (request.allHTTPHeaderFields ?? [:]).merging(additionalHeaders)
            }
        }
        
        return request
    }
}

extension Dictionary {
    func merging(_ other: [Key: Value]) -> [Key: Value] {
        var merged = self
        other.forEach {
            merged[$0.key] = $0.value
        }
        return merged
    }
}

protocol HttpBody {
    var body: Data { get }
    var additionalHeaders: [String: String] { get }
}

struct URLEncodedDataRequestBody: HttpBody {
    let data: [String: String]
    
    var body: Data {
        data.map { key, value in
            "\(key)=\(percentEscapeString(value))"
        }
        .joined(separator: "&")
        .utf8Encoded
    }
    
    var additionalHeaders: [String: String] {
        [
            "Content-Type": "application/json"
        ]
    }
    
    func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        return (string.addingPercentEncoding(withAllowedCharacters: characterSet) ?? string)
            .replacingOccurrences(of: " ", with: "+")
    }
}

struct JsonDataRequestBody<T: Codable>: HttpBody {
    let data: T
    
    var body: Data {
        JSONEncoder.encodeData(data)
    }
    
    var additionalHeaders: [String: String] {
        [
            "Content-Type": "application/json"
        ]
    }
}

enum HttpApiError: Error {
    case invalidUrl
    case statusCode(code: Int)
    case apiError(reason: String)
    case decodingError(localizedReason: String)
    case connectionError
    case responseMishmash(url: String)
    case cacheItemNotFound(key: String)
    case appError(localizedReason: String)
    case genericError(error: Error)
}
