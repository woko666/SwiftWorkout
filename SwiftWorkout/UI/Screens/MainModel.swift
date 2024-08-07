import Foundation
import SwiftUI

@MainActor class MainModel: ObservableObject, Injectable {
    let container: Container
    @Injected(\.appStateInteractor) var appStateInteractor
    @Injected(\.workoutsInteractor) var workoutsInteractor
    
    @Published var workouts: [WorkoutEntity] = []
    @Published var remoteStatus: RemoteWorkoutStatus = .notRequested
    @Published var filter: WorkoutFilter = .all {
        didSet {
            Task {
                await appStateInteractor.setWorkoutFilter(filter)
            }
        }
    }
        
    init(container: Container) {
        self.container = container
    }
    
    @Sendable func refreshRemote() async {
        await workoutsInteractor.refreshRemoteWorkouts()
        _ = await workoutsInteractor.getRemoteStatusStream().first(where: { $0 == .loaded || $0 == .errorLoading })
    }
    
    func navigateTo(route: NavigationRoute) {
        Task { await appStateInteractor.pushNavigationRoute(route) }
    }
    
    func editWorkout(_ id: String) {
        Task {
            await appStateInteractor.setSelectedWorkoutId(id)
            await appStateInteractor.pushNavigationRoute(.editWorkout)
        }
    }
    
    func updateWorkouts(_ workouts: [WorkoutEntity]) {
        self.workouts = workouts
    }
    
    func updateRemoteStatus(_ remoteStatus: RemoteWorkoutStatus) {
        self.remoteStatus = remoteStatus
    }
    
    func initialize() async {
        filter = await appStateInteractor.workoutFilter
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                for await workouts in await self.workoutsInteractor.getWorkoutStream() {
                    if Task.isCancelled { return }
                    await self.updateWorkouts(workouts)
                }
            }
            
            group.addTask {
                for await remoteStatus in await self.workoutsInteractor.getRemoteStatusStream() {
                    if Task.isCancelled { return }
                    await self.updateRemoteStatus(remoteStatus)
                }
            }
        }
    }
}
