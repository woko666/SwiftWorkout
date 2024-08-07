import Foundation

protocol AppSettingsRepo: Actor {
    var installationId: String { get }
    var workoutFilter: WorkoutFilter { get }
    func setWorkoutFilter(_ filter: WorkoutFilter) async
}

actor AppSettingsRepoImpl: UserDefaultsRepository, AppSettingsRepo {
    private let installationIdKey = "installationId"
    private let workoutFilterKey = "workoutFilter"
    
    var installationId: String {
        if let id = get(installationIdKey) {
            return id
        }
        let generatedId = UUID().uuidString
        set(installationIdKey, value: generatedId)
        return generatedId
    }
    
    var workoutFilter: WorkoutFilter {
        decodeJson(workoutFilterKey) ?? .all
    }
    
    func setWorkoutFilter(_ filter: WorkoutFilter) async {
        encodeJson(workoutFilterKey, value: filter)
    }
}
