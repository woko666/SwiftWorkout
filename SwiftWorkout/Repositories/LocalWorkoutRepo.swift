import Foundation
import AsyncExtensions

protocol LocalWorkoutRepo: WorkoutRepo { }

actor UserDefaultsWorkoutRepo: UserDefaultsRepository, LocalWorkoutRepo, Initializable {
    private let workoutsKey = "workouts"
    
    init() {
        if get(workoutsKey) == nil {
            encodeJson(workoutsKey, value: placeholderData)
        }
    }
    
    let workoutStream = AsyncCurrentValueSubject<[WorkoutEntity]>([])
    private let placeholderData: [WorkoutData] = [
        .init(id: UUID().uuidString, icon: .cycle, name: "A HIIT cycling session", location: "Around the neighborhood", durationSeconds: 5400),
        .init(id: UUID().uuidString, icon: .walk, name: "Leisurely walk", location: "Prague castle", durationSeconds: 7200),
        .init(id: UUID().uuidString, icon: .yoga, name: "Power yoga", location: "Tokyo Tower", durationSeconds: 3300),
        .init(id: UUID().uuidString, icon: .strength, name: "Rippetoe's Starting Strength", location: "Local gym", durationSeconds: 2700),
        .init(id: UUID().uuidString, icon: .swim, name: "Triathlon training", location: "Swimming pool", durationSeconds: 4500)
    ]
    
    private var workoutData: [WorkoutData] {
        get {
            decodeJson(workoutsKey) ?? []
        }
        
        set {
            encodeJson(workoutsKey, value: newValue)
        }
    }
    
    func initialize() async throws {
        workoutStream.send(workoutData.map(\.entity))
    }
    
    func getWorkout(_ id: String) async -> WorkoutEntity? {
        workoutData.first(where: { $0.id == id })?.entity
    }
    
    func upsertWorkout(_ workout: WorkoutEntity) async throws {
        let newData = workoutData.filter { $0.id != workout.id } + [workout.data]
        workoutData = newData
        workoutStream.send(newData.map(\.entity))
    }
    
    func getWorkoutStream() -> AsyncStream<[WorkoutEntity]> {
        workoutStream.asAsyncStream()
    }
}

extension WorkoutEntity {
    fileprivate var data: WorkoutData {
        .init(id: id, icon: icon, name: name, location: location, durationSeconds: durationSeconds)
    }
}

private struct WorkoutData: Codable {
    var id: String
    var icon: WorkoutIcon
    var name: String
    var location: String
    var durationSeconds: Int
}

extension WorkoutData {
    var entity: WorkoutEntity {
        .init(id: id, icon: icon, name: name, location: location, durationSeconds: durationSeconds, storage: .local)
    }
}
