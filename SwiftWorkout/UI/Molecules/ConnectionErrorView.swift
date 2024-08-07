import SwiftUI

struct ConnectionErrorView: View {
    let text: String
    var action: Callback
    
    var body: some View {
        VStack(spacing: Theme.spaces.s3) {
            HStack(spacing: Theme.spaces.s3) {
                SystemImageView("exclamationmark.triangle", size: Theme.dimensions.iconBig, color: Theme.colors.primary)
                
                TextView(text, .title)
                    .stretchMultiline(.leading)
            }
            
            SystemImageView("arrow.clockwise.circle", size: Theme.dimensions.iconStandard, color: Theme.colors.defaultText)
        }
        .padding(Theme.spaces.s3)
        .background(
            RoundedRectangle(cornerRadius: Theme.dimensions.cornerRadius)
                .stroke(Theme.colors.defaultText, lineWidth: 1)
                .fill(Theme.colors.secondaryBackground)
                .foregroundColor(Theme.colors.background)
                .shadow(color: Theme.colors.shadow, radius: 3, x: 0, y: 0)
        )
        .onTapRectangle(perform: action)
    }
}

#Preview {
    ConnectionErrorView(text: "Some text goes here, it can be rather long", action: {})
        .padding()
}
