//
//  Song.swift
//  Looplay
//
//  Created by Amadou on 09.07.2025.
//

import Foundation
import SwiftData

@Model
class Song: Identifiable, Equatable {
    var id: UUID
    var title: String
    var artist: String
    var createdDate: Date

    init(id: UUID = UUID(), title: String, artist: String, createdDate: Date = Date()) {
        self.id = id
        self.title = title
        self.artist = artist
        self.createdDate = createdDate
    }
}

