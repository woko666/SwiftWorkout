import Foundation
import SwiftUI

struct AddWorkoutScreenView: View {
    @StateObject var viewModel: WorkoutDetailModel
    
    var body: some View {
        WorkoutDetailTemplateView(
            icon: $viewModel.icon,
            name: $viewModel.name,
            location: $viewModel.location,
            durationSeconds: $viewModel.durationSeconds,
            storage: $viewModel.storage,
            action: .add,
            actionState: viewModel.actionState,
            sendAction: viewModel.upsert
        )
        .task { await viewModel.initializeNew() }
        .onDisappear { viewModel.cleanup() }
        .alert("There was an error adding your workout. Please try again.", isPresented: $viewModel.isConnectionAlertShown) {
            Button("OK", role: .cancel) { }
        }
    }
}
