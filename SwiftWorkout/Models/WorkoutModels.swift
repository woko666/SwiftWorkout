import Foundation
import SwiftUI

enum WorkoutFilter: String, Codable, Identifiable, Hashable, CaseIterable {
    var id: String { rawValue }
    
    case all
    case local
    case remote
    
    var title: String {
        switch self {
        case .all: "All"
        case .local: "Local"
        case .remote: "Remote"
        }
    }
}

extension WorkoutIcon: Codable, Identifiable, Hashable {
    var id: String { rawValue }
}

extension WorkoutEntity {
    func isVisible(_ filter: WorkoutFilter) -> Bool {
        switch filter {
        case .all: true
        case .local: storage == .local
        case .remote: storage == .remote
        }
    }
}

enum WorkoutDetailAction {
    case add
    case edit
    
    var title: String {
        switch self {
        case .add: "Enter a new workout"
        case .edit: "Edit workout"
        }
    }
    
    var image: String {
        switch self {
        case .add: "plus.circle"
        case .edit: "pencil.circle"
        }
    }
    
    var actionStart: String {
        switch self {
        case .add: "Add workout"
        case .edit: "Edit workout"
        }
    }
    
    var actionProgress: String {
        switch self {
        case .add: "Adding workout..."
        case .edit: "Editing workout..."
        }
    }
}

extension WorkoutStorage: Identifiable, Hashable {
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .local: "Local"
        case .remote: "Remote"
        }
    }
    
    var color: Color {
        switch self {
        case .local: Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
        case .remote: Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
        }
    }
    
    var icon: String {
        switch self {
        case .local: "smartphone"
        case .remote: "icloud"
        }
    }    
}

extension WorkoutIcon {
    var systemIcon: String {
        switch self {
        case .walk: "figure.walk"
        case .run: "figure.run"
        case .cycle: "figure.outdoor.cycle"
        case .swim: "figure.pool.swim"
        case .strength: "figure.strengthtraining.traditional"
        case .yoga: "figure.yoga"
        }
    }
}
