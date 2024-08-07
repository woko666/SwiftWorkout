import Foundation
import SwiftUI

struct WorkoutDetailTemplateView: View {
    @Binding var icon: WorkoutIcon
    @Binding var name: String
    @Binding var location: String
    @Binding var durationSeconds: Int
    @Binding var storage: WorkoutStorage
    
    let action: WorkoutDetailAction
    let actionState: ActionState
    
    let sendAction: Callback
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: Theme.spaces.s2) {
                    WorkoutSelectionView(selected: $icon, width: geometry.size.width - Theme.spaces.s3 * 2)
                    
                    FormFieldView(text: $name, placeholder: "Workout name")
                    
                    FormFieldView(text: $location, placeholder: "Location")
                    
                    DurationPickerView(durationSeconds: $durationSeconds, width: geometry.size.width - Theme.spaces.s3 * 2)
                    
                    if action == .add {
                        Picker("", selection: $storage) {
                            ForEach(WorkoutStorage.allCases) { storage in
                                Text(storage.title).tag(storage)
                            }
                        }
                        .pickerStyle(.segmented)
                    } else {
                        HStack(spacing: Theme.spaces.s2) {
                            TextView(storage.title, .subtitle)
                            
                            SystemImageView(storage.icon, size: Theme.dimensions.iconSmall, color: Theme.colors.defaultText)
                        }
                        .stretch(.leading)
                    }
                }
                .background(
                    Theme.colors.background
                        .onTapRectangle { UIApplication.shared.endEditing() }
                )
                .padding(Theme.spaces.s3)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                ActivityButtonView(systemImage: action.image, text: actionState == .processing ? action.actionProgress : action.actionStart, isLoading: actionState == .processing, action: sendAction)
                    .padding(Theme.spaces.s4)
            }
            .navigationBarTitle(Text(action.title))
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        UIApplication.shared.endEditing()
                    }
                }
            }
        }
    }
}

#Preview {
    Group {
        WorkoutDetailTemplateView(
            icon: .constant(.run),
            name: .constant("Some name"),
            location: .constant("Some location"),
            durationSeconds: .constant(35*60 + 30),
            storage: .constant(.local),
            action: .edit,
            actionState: .noAction,
            sendAction: {}
        )
    }
}
