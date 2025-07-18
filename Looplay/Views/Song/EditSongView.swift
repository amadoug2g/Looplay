//
//  EditSongView.swift
//  Looplay
//
//  Created by Amadou on 15.07.2025.
//

import SwiftUI
import SwiftData

struct EditSongView: View {
    @Environment(\.dismiss) private var dismiss
    
    let song: Song
    
    @State private var title: String = ""
    @State private var artist: String = ""
    @State private var mastery: Int = 0
    
    private var changed: Bool {
        title   != song.title
        || artist  != song.artist
        || mastery != song.mastery
    }
    
    var body: some View {
        Form {
            Section("Song") {
                TextField("Title", text: $title)
                TextField("Artist", text: $artist)
            }
            
            Section("Mastery") {
                RatingView(rating: $mastery, showHint: true)
            }
        }
        .navigationTitle("Edit Song")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Update") {
                song.title   = title
                song.artist  = artist
                song.mastery = mastery
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!changed)

        }
        .onAppear {
            title = song.title
            artist = song.artist
            mastery = song.mastery
        }
    }
}
