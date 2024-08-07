import Foundation
import SwiftUI

struct FormFieldView: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(spacing: Theme.spaces.s2) {
            TextView(placeholder, .body, .secondaryText)
                .stretch(.leading)
            
            TextField("", text: $text)
                .textFieldStyle(RoundedBackground())
                .padding(.leading, Theme.spaces.s1)
        }
    }
}

struct RoundedBackground: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View { // swiftlint:disable:this identifier_name
        configuration
            .padding(Theme.spaces.s2)
            .background(
                RoundedRectangle(cornerRadius: Theme.dimensions.cornerRadius)
                    .foregroundColor(Theme.colors.secondaryBackground)
            )
    }
}

#Preview {
    FormFieldView(text: .constant("Some text"), placeholder: "Placeholder text")
}
