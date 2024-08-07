import Foundation
import AsyncExtensions
import AsyncAlgorithms

protocol WorkoutsInteractor: Actor {
    func getWorkout(_ id: String) async -> WorkoutEntity?
    func getWorkoutStream() async -> AsyncStream<[WorkoutEntity]>
    func getRemoteStatusStream() async -> AsyncStream<RemoteWorkoutStatus>
    func upsertWorkout(_ workout: WorkoutEntity) async throws
    func refreshRemoteWorkouts() async
}

actor WorkoutsInteractorImpl: WorkoutsInteractor, Injectable, Initializable {
    @Injected(\.localWorkoutRepo) var localWorkoutRepo
    @Injected(\.remoteWorkoutRepo) var remoteWorkoutRepo
    
    let container: Container
    let remoteStatusStream = AsyncCurrentValueSubject<RemoteWorkoutStatus>(.notRequested)
    init(container: Container) {
        self.container = container
    }
    
    func initialize() async throws {
        await refreshRemoteWorkouts()
    }
    
    func getWorkoutStream() async -> AsyncStream<[WorkoutEntity]> {
        await combineLatest(localWorkoutRepo.getWorkoutStream(), remoteWorkoutRepo.getWorkoutStream())
            .map { $0 + $1 }
            .asAsyncStream()
    }
    
    func getRemoteStatusStream() async -> AsyncStream<RemoteWorkoutStatus> {
        await remoteWorkoutRepo.getStatusStream()
    }
    
    func upsertWorkout(_ workout: WorkoutEntity) async throws {
        if workout.storage == .local {
            try await localWorkoutRepo.upsertWorkout(workout)
        } else if workout.storage == .remote {
            try await remoteWorkoutRepo.upsertWorkout(workout)
        }
    }
    
    func refreshRemoteWorkouts() async {
        await remoteWorkoutRepo.refresh()
    }
    
    func getWorkout(_ id: String) async -> WorkoutEntity? {
        if let result = await localWorkoutRepo.getWorkout(id) {
            return result
        }
        return await remoteWorkoutRepo.getWorkout(id)
    }
}
