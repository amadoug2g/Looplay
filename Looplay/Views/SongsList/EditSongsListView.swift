//
//  EditSongsListView.swift
//  Looplay
//
//  Created by Amadou on 18.07.2025.
//

import SwiftUI
import SwiftData

struct EditSongsListView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \Song.title) private var allSongs: [Song]
    var songsList: SongsList

    @State private var selectedSongs: Set<Song> = []

    var body: some View {
        NavigationStack {
            List(allSongs, id: \.self, selection: $selectedSongs) { song in
                HStack {
                    Text(song.title)
                    Spacer()
                    if selectedSongs.contains(song) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    toggleSelection(song)
                }
            }
            .navigationTitle("Add Songs")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                selectedSongs = Set(songsList.songs)
            }
        }
    }

    private func toggleSelection(_ song: Song) {
        if selectedSongs.contains(song) {
            selectedSongs.remove(song)
        } else {
            selectedSongs.insert(song)
        }
    }

    private func save() {
        songsList.songs = Array(selectedSongs)
        try? context.save()
    }
}
