import Foundation
import Combine

actor HttpRequestProvider {
    let baseUrl: String
    let urlSession: URLSession
        
    init(baseUrl: String, urlSession: URLSession) {
        self.baseUrl = baseUrl
        self.urlSession = urlSession
    }

    func fetchDecode<Value>(endpoint: HttpApiCall, httpCodes: HTTPCodes) async throws -> Value where Value: Decodable {
        let rawValue = try await fetch(endpoint: endpoint, httpCodes: httpCodes)
        return try JSONDecoder.unsafeDecode(Value.self, from: rawValue)
    }
    
    func fetchData(endpoint: HttpApiCall, httpCodes: HTTPCodes) async throws -> Data {
        try await fetch(endpoint: endpoint, httpCodes: httpCodes)
    }
    
    private func fetch(endpoint: HttpApiCall, httpCodes: HTTPCodes) async throws -> Data {
        let request = try endpoint.urlRequest(baseUrl: baseUrl)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HttpApiError.responseMishmash(url: baseUrl)
        }
        guard httpCodes ~= httpResponse.statusCode else {
            throw HttpApiError.statusCode(code: httpResponse.statusCode)
        }
        return data
    }
}
