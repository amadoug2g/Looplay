//
//  PracticeDuration.swift
//  Looplay
//
//  Created by Amadou on 10.07.2025.
//

/// 1. Define your duration options as an enum
enum PracticeDuration: Int, CaseIterable, Identifiable {
    case fiveSeconds   = 5
    case tenSeconds    = 10
    case fifteenSeconds = 15
    case twentySeconds  = 20
    case thirtySeconds  = 30
    case oneMinute      = 60

    // Conform to Identifiable
    var id: PracticeDuration { self }

    // Human-readable label
    var displayName: String {
        switch self {
        case .fiveSeconds:    return "5 seconds"
        case .tenSeconds:     return "10 seconds"
        case .fifteenSeconds: return "15 seconds"
        case .twentySeconds:  return "20 seconds"
        case .thirtySeconds:  return "30 seconds"
        case .oneMinute:      return "1 minute"
        }
    }
}
