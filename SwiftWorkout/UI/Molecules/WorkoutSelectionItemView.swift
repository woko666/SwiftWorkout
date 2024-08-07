import SwiftUI

struct WorkoutSelectionItemView: View {
    let workout: WorkoutIcon
    let isSelected: Bool
    
    var body: some View {
        SingleAxisGeometryReader { width in
            ZStack {
                Circle()
                    .fill(isSelected ? Theme.colors.primary : Theme.colors.secondaryBackground)
                
                SystemImageView(workout.systemIcon, size: width * 0.7, color: isSelected ? Theme.colors.inverseText : Theme.colors.defaultText)
            }
        }
        .padding(Theme.spaces.s2)
        .contentShape(Circle())
    }
}

#Preview {
    VStack(spacing: Theme.spaces.s4) {
        WorkoutSelectionItemView(workout: .cycle, isSelected: true)
            .frame(size: Theme.dimensions.iconBig * 2)
        WorkoutSelectionItemView(workout: .cycle, isSelected: false)
            .frame(size: Theme.dimensions.iconBig * 3)
    }
}
