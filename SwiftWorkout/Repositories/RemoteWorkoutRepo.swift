import Foundation
import AsyncExtensions

protocol RemoteWorkoutRepo: WorkoutRepo {
    func getStatusStream() -> AsyncStream<RemoteWorkoutStatus>
    func refresh() async
}

actor WebWorkoutRepo: WebRepository, RemoteWorkoutRepo, Injectable {
    @Injected(\.appSettingsRepo) var appSettingsRepo
    
    let container: Container
    let requestProvider: HttpRequestProvider
    let statusStream = AsyncCurrentValueSubject<RemoteWorkoutStatus>(.notRequested)
    let workoutStream = AsyncCurrentValueSubject<[WorkoutEntity]>([])
    var fetchTask: Task<Void, Never>?
    init(container: Container, requestProvider: HttpRequestProvider) {
        self.container = container
        self.requestProvider = requestProvider
    }
    
    private var headers: [String: String] {
        get async {
            ["installationId": await appSettingsRepo.installationId]
        }
    }
    
    func getWorkout(_ id: String) async -> WorkoutEntity? {
        workoutStream.value.first(where: { $0.id == id })
    }
    
    func getWorkoutStream() -> AsyncStream<[WorkoutEntity]> {
        workoutStream.asAsyncStream()
    }
    
    func getStatusStream() -> AsyncStream<RemoteWorkoutStatus> {
        statusStream.asAsyncStream()
    }
    
    func refresh() async {
        statusStream.send(.loading)
        fetchTask = Task {
            await self.doRefresh()
        }
    }
    
    func doRefresh() async {
        statusStream.send(.loading)
        do {
            let results = try await fetch(GetWorkoutsCall(headers: headers), decodeTo: [WorkoutData].self)
            try Task.checkCancellation()
            workoutStream.send(results.map(\.entity))
            statusStream.send(.loaded)
        } catch {
            if error is CancellationError {
                // Skip as a new request is already in progress
            } else {
                statusStream.send(.errorLoading)
            }
        }
    }
    
    func upsertWorkout(_ workout: WorkoutEntity) async throws {
        _ = try await fetch(UpsertWorkoutsCall(body: JsonDataRequestBody(data: workout.data), headers: headers))
        workoutStream.send(workoutStream.value.filter { $0.id != workout.id } + [workout])
    }
    
    private struct GetWorkoutsCall: HttpApiCall {
        var path: String = "workouts"
        var method: HttpMethod = .get
        var headers: [String: String]?
    }
    
    private struct UpsertWorkoutsCall: HttpApiCall {
        var path: String = "workout"
        var method: HttpMethod = .post
        var body: HttpBody?
        var headers: [String: String]?
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
        .init(id: id, icon: icon, name: name, location: location, durationSeconds: durationSeconds, storage: .remote)
    }
}
