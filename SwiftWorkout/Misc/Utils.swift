import Foundation

protocol Initializable {
    func initialize() async throws
}

typealias Callback = () -> Void
typealias StringCallback = (String) -> Void
typealias SendableCallback = @Sendable () async -> Void
