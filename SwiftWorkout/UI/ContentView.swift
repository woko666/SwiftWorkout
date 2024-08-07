import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            MainScreenView(viewModel: MainModel(container: viewModel.container))
                .navigationDestination(for: NavigationRoute.self) { item in
                    switch item {
                    case .addWorkout: AddWorkoutScreenView(viewModel: WorkoutDetailModel(container: viewModel.container))
                    case .editWorkout: EditWorkoutScreenView(viewModel: WorkoutDetailModel(container: viewModel.container))
                    default: fatalError("Unable to navigate to the main screen - invalid state")
                    }
                }
                .navigationBarTitleDisplayMode(.large)
        }
        .accentColor(Theme.colors.primary)
        .task { await viewModel.startup() }
    }
}
