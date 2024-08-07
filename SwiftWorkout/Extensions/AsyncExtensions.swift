import Foundation
import AsyncExtensions
import Combine

fileprivate extension AsyncStream {
    init<Base: AsyncSequence>(from sequence: Base, file: StaticString = #filePath, line: UInt = #line) where Element == Base.Element {
        var iterator = sequence.makeAsyncIterator()
        // FIXME: In later swift versions, AsyncSequence protocol will likely have an associated error type.
        // FIXME: For now, produce an assertionFailure to let developer know to use an AsyncThrowingStream instead.
        self.init {
            do {
                return try await iterator.next()
            } catch {
                assertionFailure("AsyncSequence threw \(error.localizedDescription). Use AsyncThrowingStream instead", file: (file), line: line)
                return nil
            }
        }
    }
}

fileprivate extension AsyncThrowingStream {
    init<Base: AsyncSequence>(from sequence: Base) where Element == Base.Element, Failure == Error {
        var iterator = sequence.makeAsyncIterator()
        self.init {
            try await iterator.next()
        }
    }
}

extension AsyncSequence {
    /// Type erases the `AsyncSequence` into an `AsyncStream`
    /// - Returns: An `AsyncStream` created from the base `AsyncSequence`
    ///
    /// - Note: AsyncSequences do not expose their error type.
    /// So this function is available for both throwing and non-throwing `AsyncSequences`.
    /// It will produce an `assertionFailure` at runtime if the base sequence throws.
    func asAsyncStream(file: StaticString = #filePath, line: UInt = #line) -> AsyncStream<Element> {
        AsyncStream(from: self, file: file, line: line)
    }

    /// Type erases the `AsyncSequence` into an `AsyncThrowingStream`
    /// - Returns: An `AsyncThrowingStream` from the base `AsyncSequence`
    func asAsyncThrowingStream() -> AsyncThrowingStream<Element, Error> {
        AsyncThrowingStream(from: self)
    }
}

/// Creates an asynchronous sequence of elements from many underlying asynchronous sequences
public func merge<Base: AsyncSequence>(
  _ bases: [Base]
) -> AsyncMergeSequence<Base> {
  AsyncMergeSequence(bases)
}

extension Task {
  func eraseToAnyCancellable() -> AnyCancellable {
        AnyCancellable(cancel)
    }
}
