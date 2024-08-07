import Foundation
import SwiftUI
import Combine

@MainActor class WorkoutDetailModel: ObservableObject, Injectable {
    let container: Container
    @Injected(\.appStateInteractor) var appStateInteractor
    @Injected(\.workoutsInteractor) var workoutsInteractor
    
    var id = UUID().uuidString
    @Published var icon: WorkoutIcon = .walk
    @Published var name: String = ""
    @Published var location: String = ""
    @Published var durationSeconds: Int = 0
    @Published var storage: WorkoutStorage = .local
    @Published var actionState: ActionState = .noAction
    @Published var isConnectionAlertShown = false
    
    private var upsertAction: AnyCancellable?
    
    init(container: Container) {
        self.container = container
    }
    
    func upsert() {
        actionState = .processing
        upsertAction = Task { @MainActor in
            do {
                _ = try await self.workoutsInteractor.upsertWorkout(.init(id: id, icon: icon, name: name, location: location, durationSeconds: durationSeconds, storage: storage))
                try Task.checkCancellation()
                actionState = .noAction
                await appStateInteractor.popNavigationRoute()
            } catch {
                if error is CancellationError {
                    // Skip as a new request is already in progress
                } else {
                    actionState = .error
                    isConnectionAlertShown = true
                }
            }
        }
        .eraseToAnyCancellable()
    }
    
    func initializeNew() async {
        let filter = await appStateInteractor.workoutFilter
        if filter == .remote {
            storage = .remote
        }
    }
    
    func initializeExisting() async {
        guard let selectedWorkoutId = await appStateInteractor.selectedWorkoutId,
              let workout = await workoutsInteractor.getWorkout(selectedWorkoutId) else {
            // Some glitch has occurred, let's solve it more gracefully later. For now just go back
            await appStateInteractor.popNavigationRoute()
            return
        }
        id = workout.id
        icon = workout.icon
        name = workout.name
        location = workout.location
        durationSeconds = workout.durationSeconds
        storage = workout.storage
    }
    
    func cleanup() {
        upsertAction?.cancel()
    }
}
