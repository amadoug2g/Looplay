//
//  Preview.swift
//  Looplay
//
//  Created by Amadou on 09.07.2025.
//

import Foundation
import SwiftData

struct Preview {
    let container: ModelContainer
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            container = try ModelContainer(for: Song.self, configurations: config)
        } catch {
            fatalError("Could not create preview container")
        }
    }
    
    func addExample(_ examples: [Song]) {
        Task { @MainActor in
            examples.forEach { example in
                container.mainContext.insert(example)
            }
        }
    }
}
