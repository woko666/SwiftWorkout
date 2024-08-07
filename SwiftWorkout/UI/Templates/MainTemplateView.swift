import Foundation
import SwiftUI

struct MainTemplateView: View {
    @Binding var filter: WorkoutFilter
    let workouts: [WorkoutEntity]
    let remoteStatus: RemoteWorkoutStatus
    let reloadRemote: SendableCallback
    let addWorkout: Callback
    let editWorkout: StringCallback
    
    func getMainainContent(bottomPadding: CGFloat) -> some View {
        ScrollView {
            LazyVStack(spacing: Theme.spaces.s2) {
                if filter != .local, remoteStatus == .errorLoading {
                    ConnectionErrorView(text: "An error has occurred while fetching your remote workouts. Please try again.", action: { Task { await reloadRemote() } })
                        .padding(Theme.spaces.s3)
                }
                
                ForEach(workouts.filter { $0.isVisible(filter) }) { workout in
                    WorkoutItemView(workout: workout, action: { editWorkout(workout.id) })
                }
                
                Spacer()
            }
            .padding(.bottom, bottomPadding)
        }
        .refreshable(action: reloadRemote)
    }
    
    func getAddButton(_ insets: EdgeInsets) -> some View {
        CircularImageButtonView(systemImage: "plus", action: addWorkout)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: -insets.bottom, trailing: -insets.trailing))
            .padding(EdgeInsets(top: 0, leading: 0, bottom: Theme.spaces.s4, trailing: Theme.spaces.s4))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: Theme.spaces.s2) {
                Text("SwiftWorkout")
                    .font(.system(size: 48).bold())
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .blue, .green, .yellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Picker("", selection: $filter) {
                    ForEach(WorkoutFilter.allCases) { filter in
                        Text(filter.title).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .overlay(alignment: .topTrailing) {
                    if remoteStatus == .loading {
                        ActivityIndicatorView(color: Theme.colors.primary)
                            .padding(6)
                    }
                }
                
                getMainainContent(bottomPadding: geometry.safeAreaInsets.bottom)
            }
            .padding(Theme.spaces.s3)
            .ignoresSafeArea(.container, edges: .bottom)
            .background(Theme.colors.background)
            .overlay(alignment: .bottomTrailing) {
                getAddButton(geometry.safeAreaInsets)
            }
        }
    }
}

#Preview {
    MainTemplateView(
        filter: .constant(.all),
        workouts: (1...10).map {
            .init(id: "id\($0)", icon: .run, name: "Workout name $0", location: "Some location", durationSeconds: 60, storage: ($0 % 2) == 0 ? .remote : .local)
        },
        remoteStatus: .loading,
        reloadRemote: { },
        addWorkout: { },
        editWorkout: {_ in}
    )
}
