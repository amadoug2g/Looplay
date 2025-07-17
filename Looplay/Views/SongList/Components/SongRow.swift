//
//  SongRow.swift
//  Looplay
//
//  Created by Amadou on 15.07.2025.
//

import SwiftUI

struct SongRow: View {
    let song: Song
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(song.title)
                .font(.headline)
            Text(song.artist)
                .font(.subheadline)
            RatingView(rating: .constant(song.mastery))
                        .allowsHitTesting(false)
        }
        .padding(.vertical, 4)
    }
}
