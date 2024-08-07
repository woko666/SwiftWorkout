import Foundation

struct WorkoutEntity: Equatable, Identifiable {
    var id: String
    var icon: WorkoutIcon
    var name: String
    var location: String // MKLocalSearchCompleter later?
    var durationSeconds: Int
    var storage: WorkoutStorage
}

enum WorkoutIcon: String, Equatable, CaseIterable {
    case walk
    case run
    case cycle
    case swim
    case strength
    case yoga
}

enum WorkoutStorage: String, Equatable, CaseIterable {
    case local
    case remote
}

enum RemoteWorkoutStatus: String, Equatable, CaseIterable {
    case notRequested
    case loading
    case loaded
    case errorLoading
}
