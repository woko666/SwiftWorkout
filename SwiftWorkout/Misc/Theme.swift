import SwiftUI

class Theme: ObservableObject {
    static let colors: Colors = Colors()
    static let typography = Typography()
    static let spaces = Spaces()
    static let dimensions = Dimensions()
    static let opacity = Opacities()
    
    struct Colors {
        var background: Color = .white
        var secondaryBackground: Color = Color(#colorLiteral(red: 0.9357877208, green: 0.9357877208, blue: 0.9357877208, alpha: 1))
        var primary: Color = .red
        var defaultText: Color = .black
        var secondaryText: Color = Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        var inverseText: Color = .white
        var shadow: Color = Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 41.05))
    }
    
    struct Typography {
        func getFont(size: CGFloat, weight: Font.Weight) -> Font {
            Font.system(size: size, weight: weight)
        }
        
        func getFont(_ variant: TextVariant) -> Font {
            switch variant {
            case .headline:
                return getFont(size: 22, weight: .medium)
            case .title:
                return getFont(size: 20, weight: .medium)
            case .subtitle:
                return getFont(size: 16, weight: .regular)
            case .body:
                return getFont(size: 14, weight: .regular)
            case .caption:
                return getFont(size: 10, weight: .regular)
            case .button:
                return getFont(size: 13, weight: .bold)
            }
        }
        
        func configure(_ text: Text, variant: TextVariant) -> Text {
            return text.font(getFont(variant))
        }
    }
    
    struct Spaces {
        /// `2`
        var s0: CGFloat = 2
        /// `4`
        var s1: CGFloat = 4
        /// `8`
        var s2: CGFloat = 8
        /// `12`
        var s3: CGFloat = 12
        /// `16`
        var s4: CGFloat = 16
        /// `24`
        var s5: CGFloat = 24
        /// `48`
        var s6: CGFloat = 48
        /// `64`
        var s7: CGFloat = 64
    }
    
    struct Dimensions {
        /// `8`
        var cornerRadius: CGFloat = 8.0
        
        /// `16`
        var iconSmall: CGFloat = 16.0
        /// `24`
        var iconStandard: CGFloat = 24.0
        
        /// `42`
        var iconBig: CGFloat = 42.0
        
        /// `64`
        var iconHuge: CGFloat = 64.0
        
        /// `1.5`
        var borderSize: CGFloat = 1.5
    }
    
    struct Opacities {
        /// `0.63`
        var shadow: Double = 0.3
    }
}

enum TextVariant: String, CaseIterable {
    case headline
    case title
    case subtitle
    case body
    case caption
    case button
}

enum ThemeColor: String, Equatable {
    case background
    case primary
    case defaultText
    case secondaryText
    case inverseText
}

extension ThemeColor {
    var value: Color {
        switch self {
        case .background: Theme.colors.background
        case .primary: Theme.colors.primary
        case .defaultText: Theme.colors.defaultText
        case .secondaryText: Theme.colors.secondaryText
        case .inverseText: Theme.colors.inverseText
        }
    }
}
