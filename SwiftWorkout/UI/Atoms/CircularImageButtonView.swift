import SwiftUI

struct CircularImageButtonView: View {
    let systemImage: String
    var action: Callback?
    
    var body: some View {
        Button(
            action: {
                action?()
            }, label: {
                ZStack {
                    Circle()
                        .fill(Theme.colors.primary)
                    
                    SystemImageView(systemImage, size: Theme.dimensions.iconBig, color: Theme.colors.inverseText)
                }
                .frame(width: Theme.dimensions.iconHuge, height: Theme.dimensions.iconHuge)
                .padding(Theme.spaces.s2)
                .contentShape(Circle())
            }
        )
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        CircularImageButtonView(systemImage: "plus", action: {})
    }
}
