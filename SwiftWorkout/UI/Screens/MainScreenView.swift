import Foundation
import SwiftUI

struct MainScreenView: View {
    @StateObject var viewModel: MainModel
    
    var body: some View {
        MainTemplateView(
            filter: $viewModel.filter,
            workouts: viewModel.workouts,
            remoteStatus: viewModel.remoteStatus,
            reloadRemote: viewModel.refreshRemote,
            addWorkout: { viewModel.navigateTo(route: .addWorkout) },
            editWorkout: viewModel.editWorkout
        )
        .task { await viewModel.initialize() }
    }
}
