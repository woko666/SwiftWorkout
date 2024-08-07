import SwiftUI

struct WorkoutItemView: View {
    let workout: WorkoutEntity
    var action: Callback
    
    var body: some View {
        HStack(spacing: Theme.spaces.s3) {
            SystemImageView(workout.icon.systemIcon, size: Theme.dimensions.iconBig, color: Theme.colors.primary)
                .padding(Theme.spaces.s3)
                .background(
                    RoundedRectangle(cornerRadius: Theme.dimensions.cornerRadius)
                        .foregroundColor(Theme.colors.secondaryBackground)
                )
            
            VStack(spacing: Theme.spaces.s2) {
                TextView(workout.name, .subtitle, .defaultText)
                    .stretchMultiline(.leading)
                
                TextView("\(workout.location) • \(workout.durationSeconds.formattedTime)", .subtitle, .secondaryText)
                    .stretchMultiline(.leading)
            }
            
            SystemImageView(workout.storage.icon, size: Theme.dimensions.iconSmall, color: workout.storage.color)
                .padding(Theme.spaces.s2)
        }
        .padding(Theme.spaces.s3)
        .background(
            RoundedRectangle(cornerRadius: Theme.dimensions.cornerRadius)
                .foregroundColor(workout.storage.color.opacity(0.03))
        )
        .onTapRectangle(perform: action)
    }
}

#Preview {
    WorkoutItemView(
        workout: .init(id: "1", icon: .cycle, name: "Cycling run", location: "Prague castle", durationSeconds: 6000, storage: .remote),
        action: {}
    )
    .padding()
}
