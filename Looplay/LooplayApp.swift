//
//  LooplayApp.swift
//  Looplay
//
//  Created by Amadou on 09.07.2025.
//

import SwiftUI
import SwiftData

@main
struct LooplayApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ Song.self ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
