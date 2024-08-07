import Foundation
import Combine

protocol WebRepository {
    var requestProvider: HttpRequestProvider { get }
}

extension WebRepository {
    func fetch<Value>(_ endpoint: HttpApiCall, decodeTo: Value.Type, httpCodes: HTTPCodes = .success) async throws -> Value where Value: Decodable {
        try await requestProvider.fetchDecode(endpoint: endpoint, httpCodes: httpCodes)
    }
    
    func fetch(_ endpoint: HttpApiCall, httpCodes: HTTPCodes = .success) async throws -> Data {
        try await requestProvider.fetchData(endpoint: endpoint, httpCodes: httpCodes)
    }
}
