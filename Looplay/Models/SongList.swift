//
//  SongList.swift
//  Looplay
//
//  Created by Amadou on 17.07.2025.
//

import Foundation
import SwiftData

@Model
class SongsList {
    var name: String
    var listDescription: String
    var createdDate: Date = Date.now
    var lastModifiedDate: Date = Date.now
    var songs: [Song]

    init(
      name: String,
      description: String,
      songs: [Song] = []
    ) {
        self.name = name
        self.listDescription = description
        self.songs = songs
    }
}
