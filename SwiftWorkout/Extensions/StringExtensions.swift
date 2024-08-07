import Foundation

extension String {
    var utf8Encoded: Data {
        Data(self.utf8)
    }
}
