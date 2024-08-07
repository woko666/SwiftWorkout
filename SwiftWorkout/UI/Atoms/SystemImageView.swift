import SwiftUI

struct SystemImageView: View {
    let image: String
    let width: CGFloat
    let height: CGFloat
    let color: Color?
    
    init(_ image: String, size: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil, color: Color? = nil) {
        self.image = image
        if let size {
            self.width = size
            self.height = size
        } else {
            self.width = width ?? 0
            self.height = height ?? 0
        }
        self.color = color
    }
    
    var body: some View {
        Image(systemName: image)
            .renderingMode(.template)
            .resizable()
            .foregroundColor(color ?? Theme.colors.primary)
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}

#Preview {
    SystemImageView("mail.stack", size: 64, color: .blue)
}
