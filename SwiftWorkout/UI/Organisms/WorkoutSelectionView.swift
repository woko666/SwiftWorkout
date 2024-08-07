import SwiftUI

struct WorkoutSelectionView: View {
    @Binding var selected: WorkoutIcon
    let width: CGFloat
    
    var body: some View {
        EqualWidthColumnGridView(
            width: width,
            columns: { $0 < 450 ? 3 : 6 },
            horizontalSpacing: Theme.spaces.s3,
            verticalSpacing: Theme.spaces.s3,
            models: WorkoutIcon.allCases,
            transform: { item, width in
                WorkoutSelectionItemView(workout: item, isSelected: item == selected)
                    .frame(size: width)
                    .onTapRectangle {
                        selected = item
                    }
            }
        )
    }
}

#Preview {
    VStack(spacing: Theme.spaces.s4) {
        WorkoutSelectionView(selected: .constant(.strength), width: 300)
    }
}
