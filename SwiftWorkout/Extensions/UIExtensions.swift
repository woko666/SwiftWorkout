import Foundation
import SwiftUI
import UIKit

extension View {
    func stretch(_ alignment: Alignment = .center) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func stretchMultiline(_ alignment: Alignment = .center) -> some View {
        stretch(alignment)
            .multilineTextAlignment(alignment.textAlignment)
            .fixedVerticalSize()
    }
    
    func fixedVerticalSize() -> some View {
        fixedSize(horizontal: false, vertical: true)
    }
    
    func fixedHorizontalSize() -> some View {
        fixedSize(horizontal: true, vertical: false)
    }
}

fileprivate extension Alignment {
    var textAlignment: TextAlignment {
        switch self {
        case .leading: .leading
        case .trailing: .trailing
        default: .center
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func onTapRectangle(perform action: @escaping () -> Void) -> some View {
        contentShape(Rectangle())
            .onTapGesture(perform: action)
    }
    
    func frame(size: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: size, height: size, alignment: alignment)
    }
}
