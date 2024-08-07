import Foundation
import AsyncExtensions

protocol WorkoutRepo: Actor {
    func getWorkout(_ id: String) async -> WorkoutEntity?
    func upsertWorkout(_ workout: WorkoutEntity) async throws
    func getWorkoutStream() -> AsyncStream<[WorkoutEntity]>
}
