//
//  AddSongView.swift
//  Looplay
//
//  Created by Amadou on 09.07.2025.
//

import SwiftUI
import SwiftData

struct NewSongView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var artist = ""
    @State private var mastery = 0

    @FocusState private var isTitleFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                TextField("Song Title", text: $title)
                    .focused($isTitleFocused)
                TextField("Artist", text: $artist)
                HStack {
                    Text("Song Mastery: ")
                    RatingView(rating: $mastery)
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Create") {
                            let newSong = Song(title: title, artist: artist, mastery: mastery)
                            context.insert(newSong)
                            dismiss()
                        }.disabled(title.isEmpty || artist.isEmpty)
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }
                }
                .onAppear {
                    isTitleFocused = true
                }
            }
            .navigationTitle("New Song")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
