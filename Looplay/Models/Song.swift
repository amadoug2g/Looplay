//
//  Song.swift
//  Looplay
//
//  Created by Amadou on 09.07.2025.
//

import Foundation
import SwiftData

@Model
class Song {
    var title: String
    var artist: String
    var createdDate: Date = Date.now
    var mastery: Int = 0


    init(title: String, artist: String, mastery: Int = 0) {
        self.title = title
        self.artist = artist
        self.mastery = mastery
    }
}

