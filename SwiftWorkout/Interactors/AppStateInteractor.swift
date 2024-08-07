import Foundation
import AsyncExtensions

protocol AppStateInteractor: Actor {
    var selectedWorkoutId: String? { get }
    var installationId: String { get async }
    var workoutFilter: WorkoutFilter { get async }
    func getNavigationCommands() async -> AsyncStream<NavigationCommand>
    func pushNavigationRoute(_ route: NavigationRoute)
    func popNavigationRoute()
    func setWorkoutFilter(_ filter: WorkoutFilter) async
    func setSelectedWorkoutId(_ id: String)
}

actor AppStateInteractorImpl: AppStateInteractor, Injectable {
    @Injected(\.appSettingsRepo) var appSettingsRepo
    
    let container: Container
    let navigationCommandStream = AsyncPassthroughSubject<NavigationCommand>()
    init(container: Container) {
        self.container = container
    }
    
    var selectedWorkoutId: String?
    
    func setSelectedWorkoutId(_ id: String) {
        selectedWorkoutId = id
    }
    
    var installationId: String {
        get async {
            await appSettingsRepo.installationId
        }
    }
    
    var workoutFilter: WorkoutFilter {
        get async {
            await appSettingsRepo.workoutFilter
        }
    }
    
    func setWorkoutFilter(_ filter: WorkoutFilter) async {
        await appSettingsRepo.setWorkoutFilter(filter)
    }
    
    func getNavigationCommands() async -> AsyncStream<NavigationCommand> {
        navigationCommandStream.asAsyncStream()
    }
    
    func pushNavigationRoute(_ route: NavigationRoute) {
        navigationCommandStream.send(.push(route))
    }
    func popNavigationRoute() {
        navigationCommandStream.send(.pop)
    }
}

enum NavigationCommand {
    case push(NavigationRoute)
    case pop
}

enum NavigationRoute {
    case main
    case addWorkout
    case editWorkout
}
