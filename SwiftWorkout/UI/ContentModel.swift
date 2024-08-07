import Foundation
import SwiftUI

@MainActor class ContentModel: ObservableObject, Injectable {
    let container: Container = .default
    @Injected(\.appStateInteractor) var appStateInteractor
    
    @Published var navigationPath: [NavigationRoute] = []
        
    func startup() async {
        for await command in await appStateInteractor.getNavigationCommands() {
            switch command {
            case let .push(route):
                navigationPath.append(route)
            case .pop:
                if !navigationPath.isEmpty {
                    _ = navigationPath.popLast()
                }
            }
        }
    }
    
}
