import Foundation
import SwiftUI

struct ActivityIndicatorView: View {
    var color: Color = Theme.colors.primary
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: color))
    }
}

#Preview {
    ActivityIndicatorView(color: .red)
}
