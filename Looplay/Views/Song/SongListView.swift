//
//  SongListView.swift
//  Looplay
//
//  Created by Amadou on 10.07.2025.
//

import SwiftUI
import SwiftData
import UIKit

struct SongListView: View {
    @Environment(\.modelContext) private var context
    @State private var createNewSong : Bool = false
    @State private var showCopyAlert : Bool = false
    @State private var showImportResult : Bool = false
    @State private var importResultMessage : String = ""
    @State private var activeAlert: AlertType?
    
    let title: String
    let songs: [Song]

    var body: some View {
        NavigationStack {
            VStack {
                SongsView(songs: songs, title: title)
                .listStyle(.plain)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            createNewSong = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("New Song")
                            }
                            .font(.headline)
                        }
                        
                        Spacer()
                    } 
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button { activeAlert = .importSongs("?") } label: { Text("Import from Clipboard") }
                            Button { activeAlert = .copySongs } label: { Text("Export to Clipboard") }
                            Divider()
                            Button("Delete All Songs", role: .destructive) { activeAlert = .deleteAll }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .imageScale(.large)
                        }
                    }
                }
                .sheet(isPresented: $createNewSong) {
                    NewSongView().presentationDetents([.medium])
                }
                .alert(item: $activeAlert) { alert in
                    switch alert {
                    case .importSongs(let placeholder):
                        return Alert(
                            title: Text("Import Result!"),
                            message: Text(placeholder),
                            dismissButton: .default(Text("OK"))
                        )
                        
                    case .copySongs:
                        return Alert(
                            title: Text("Copied!"),
                            message: Text("Copied \(songs.count) songs to clipboard."),
                            dismissButton: .default(Text("OK"))
                        )
                        
                    case .deleteAll:
                        return Alert(
                            title: Text("Delete All Songs?!"),
                            message: Text("This will permanently remove all songs \(songs.count) songs from your library."),
                            primaryButton: .destructive(Text("Delete All"), action: deleteAllSongs),
                            secondaryButton: .cancel()
                        )
                    }
                }
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
        let exportText = songs
            .enumerated()
            .map { index, song in
                "#\(index + 1) \(song.title) – \(song.artist)"
            }
            .joined(separator: "\n")

        UIPasteboard.general.string = exportText

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
