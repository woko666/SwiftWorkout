import Foundation
import SwiftUI

struct EditWorkoutScreenView: View {
    @StateObject var viewModel: WorkoutDetailModel
    
    var body: some View {
        WorkoutDetailTemplateView(
            icon: $viewModel.icon,
            name: $viewModel.name,
            location: $viewModel.location,
            durationSeconds: $viewModel.durationSeconds,
            storage: $viewModel.storage,
            action: .edit,
            actionState: viewModel.actionState,
            sendAction: viewModel.upsert
        )
        .task { await viewModel.initializeExisting() }
        .onDisappear { viewModel.cleanup() }
        .alert("There was an error updating your workout. Please try again.", isPresented: $viewModel.isConnectionAlertShown) {
            Button("OK", role: .cancel) { }
        }
    }
}
