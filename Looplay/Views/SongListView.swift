//
//  SongListView.swift
//  Looplay
//
//  Created by Amadou on 10.07.2025.
//

import SwiftUI
import SwiftData
import UIKit   // for UIPasteboard

struct SongListView: View {
    @Environment(\.modelContext) private var context
    @State private var createNewSong = false
    @State private var showCopyAlert = false
    @State private var showImportResult = false
    @State private var importResultMessage = ""
    @State private var showDeleteAllConfirmation = false
    @Query(sort: \Song.title) private var songs: [Song]

    var body: some View {
        NavigationStack {
            List {
                ForEach(songs) { song in
                    VStack(alignment: .leading) {
                        Text(song.title)
                            .font(.headline)
                        Text(song.artist)
                            .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteSongs)
            }
            .listStyle(.plain)
            .navigationTitle("Songs")
            .toolbar {
                // Add button
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        createNewSong = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
                
                // Ellipsis menu
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("Import from Clipboard", action: importSongsFromClipboard)
                        Button("Export to Clipboard", action: exportSongsToClipboard)
                        Divider()
                        Button("Delete All Songs", role: .destructive) {
                            showDeleteAllConfirmation = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $createNewSong) {
                NewSongView().presentationDetents([.medium])
            }
            .alert("Copied!", isPresented: $showCopyAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Copied \(songs.count) songs to clipboard.")
            }
            .alert(importResultMessage, isPresented: $showImportResult) {
                Button("OK", role: .cancel) {}
            }
            // Delete-all confirmation
            .alert("Delete All Songs?", isPresented: $showDeleteAllConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete All", role: .destructive, action: deleteAllSongs)
            } message: {
                Text("This will permanently remove all \(songs.count) songs from your library.")
            }
        }
    }

    private func deleteSongs(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(songs[index])
            }
        }
    }
    
    private func deleteAllSongs() {
        withAnimation {
            for song in songs {
                context.delete(song)
            }
            try? context.save()
        }
    }
    
    private func exportSongsToClipboard() {
        // 1) Build a numbered, newline-separated string of "#X Title – Artist"
        let exportText = songs
            .enumerated()
            .map { index, song in
                "#\(index + 1) \(song.title) – \(song.artist)"
            }
            .joined(separator: "\n")

        // 2) Copy to clipboard
        UIPasteboard.general.string = exportText

        // 3) Show confirmation
        showCopyAlert = true
    }
    private func importSongsFromClipboard() {
        guard let clipboard = UIPasteboard.general.string,
              !clipboard.isEmpty else {
            importResultMessage = "Clipboard is empty."
            showImportResult = true
            return
        }

        let lines = clipboard
            .split(whereSeparator: \.isNewline)
            .map(String.init)

        var imported = 0, skipped = 0

        withAnimation {
            for raw in lines {
                // 1) Strip "#<digits> " prefix if present
                let trimmed: String
                if raw.hasPrefix("#"),
                   let firstSpace = raw.firstIndex(of: " ") {
                    // Drop from start up to (and including) that space
                    trimmed = String(raw[raw.index(after: firstSpace)...])
                } else {
                    trimmed = raw
                }

                // 2) Split into title / artist on en-dash or hyphen-minus
                let parts = trimmed
                    .split(separator: "–", maxSplits: 1)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                let (title, artist): (String, String)
                if parts.count == 2 {
                    (title, artist) = (parts[0], parts[1])
                } else {
                    // fallback on hyphen-minus
                    let fb = trimmed
                        .split(separator: "-", maxSplits: 1)
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                    guard fb.count == 2 else { continue }
                    (title, artist) = (fb[0], fb[1])
                }

                // 3) Skip duplicates
                if songs.contains(where: { $0.title == title && $0.artist == artist }) {
                    skipped += 1
                    continue
                }

                // 4) Insert new Song
                let newSong = Song(title: title, artist: artist)
                context.insert(newSong)
                imported += 1
            }

            // 5) Save changes
            try? context.save()
        }

        importResultMessage = "Imported \(imported) song(s). Skipped \(skipped) duplicates."
        showImportResult = true
    }
}

