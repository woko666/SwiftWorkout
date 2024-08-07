import SwiftUI

// swiftlint:disable:next identifier_name
func TextView(_ text: String, _ variant: TextVariant, _ color: ThemeColor = .defaultText) -> Text {
    Theme.typography.configure(Text(verbatim: text), variant: variant)
        .foregroundColor(color.value)
}

// swiftlint:disable:next identifier_name
func TextView(symbol: String, _ variant: TextVariant, _ color: ThemeColor) -> Text {
    Theme.typography.configure(Text(Image(systemName: symbol)), variant: variant)
        .foregroundColor(color.value)
}

#Preview  {
    VStack {
        ForEach(TextVariant.allCases, id: \.self) {
            TextView("Lorem ipsum dolor sit amet, ad per porro nihil essent.", $0, .defaultText)
                .multilineTextAlignment(.center)
                .previewDisplayName($0.rawValue)
        }
    }
}
