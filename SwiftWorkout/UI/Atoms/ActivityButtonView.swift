import SwiftUI

struct ActivityButtonView: View {
    let systemImage: String
    let text: String
    let isLoading: Bool
    var action: Callback?
    
    var body: some View {
        Button(
            action: {
                if !isLoading {
                    UIApplication.shared.endEditing()
                    action?()
                }
            }, label: {
                HStack(spacing: Theme.spaces.s3) {
                    if isLoading {
                        ActivityIndicatorView(color: Theme.colors.inverseText)
                    } else {
                        SystemImageView(systemImage, size: Theme.dimensions.iconStandard, color: Theme.colors.inverseText)
                    }
                
                    TextView(text, .button, .inverseText)
                        .fixedHorizontalSize()
                }
                .stretch(.center)
                .padding(.horizontal, Theme.spaces.s4)
                .padding(.vertical, Theme.spaces.s3)
                .background(Theme.colors.primary.opacity(isLoading ? 0.2 : 1))
                .cornerRadius(Theme.dimensions.cornerRadius)
            }
        )
    }
}

#Preview {
    VStack {
        ActivityButtonView(systemImage: "plus.circle", text: "Add workout", isLoading: false, action: {})
        ActivityButtonView(systemImage: "plus.circle", text: "Adding workout...", isLoading: true, action: {})
        ActivityButtonView(systemImage: "pencil.circle", text: "Edit workout", isLoading: false, action: {})
    }
}
