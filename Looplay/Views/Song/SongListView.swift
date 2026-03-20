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
    @State private var createNewSong: Bool = false
    @State private var importResultMessage: String = ""
    @State private var activeAlert: AlertType?

    let title: String
    let songs: [Song]

    var body: some View {
        SongsView(songs: songs, title: title)
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
                        Button {
                            importSongsFromClipboard()
                        } label: { Text("Import from Clipboard") }
                        Button {
                            exportSongsToClipboard()
                        } label: { Text("Export to Clipboard") }
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
                case .importSongs(let message):
                    return Alert(
                        title: Text("Import Result"),
                        message: Text(message),
                        dismissButton: .default(Text("OK"))
                    )
                case .copySongs:
                    return Alert(
                        title: Text("Copied!"),
                        message: Text("Copied \(songs.count) song(s) to clipboard."),
                        dismissButton: .default(Text("OK"))
                    )
                case .deleteAll:
                    return Alert(
                        title: Text("Delete All Songs?"),
                        message: Text("This will permanently remove all \(songs.count) songs from your library."),
                        primaryButton: .destructive(Text("Delete All"), action: deleteAllSongs),
                        secondaryButton: .cancel()
                    )
                }
            }
    }

    private func deleteAllSongs() {
        withAnimation {
            for song in songs {
                context.delete(song)
            }
            do {
                try context.save()
            } catch {
                print("SongListView: failed to save after delete all – \(error)")
            }
        }
    }

    private func exportSongsToClipboard() {
        let exportText = songs
            .enumerated()
            .map { index, song in "#\(index + 1) \(song.title) \u{2013} \(song.artist)" }
            .joined(separator: "\n")
        UIPasteboard.general.string = exportText
        activeAlert = .copySongs
    }

    private func importSongsFromClipboard() {
        guard let clipboard = UIPasteboard.general.string, !clipboard.isEmpty else {
            activeAlert = .importSongs("Clipboard is empty.")
            return
        }

        let lines = clipboard.split(whereSeparator: \.isNewline).map(String.init)
        var imported = 0, skipped = 0

        withAnimation {
            for raw in lines {
                // 1) Strip "#<digits> " prefix if present
                let trimmed: String
                if raw.hasPrefix("#"), let firstSpace = raw.firstIndex(of: " ") {
                    trimmed = String(raw[raw.index(after: firstSpace)...])
                } else {
                    trimmed = raw
                }

                // 2) Split on en-dash or hyphen-minus
                let parts = trimmed
                    .split(separator: "\u{2013}", maxSplits: 1)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                let (songTitle, artist): (String, String)
                if parts.count == 2 {
                    (songTitle, artist) = (parts[0], parts[1])
                } else {
                    let fb = trimmed
                        .split(separator: "-", maxSplits: 1)
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                    guard fb.count == 2 else { continue }
                    (songTitle, artist) = (fb[0], fb[1])
                }

                // 3) Skip duplicates
                if songs.contains(where: { $0.title == songTitle && $0.artist == artist }) {
                    skipped += 1
                    continue
                }

                // 4) Insert new Song
                context.insert(Song(title: songTitle, artist: artist))
                imported += 1
            }

            // 5) Save
            do {
                try context.save()
            } catch {
                print("SongListView: failed to save after import – \(error)")
            }
        }

        activeAlert = .importSongs("Imported \(imported) song(s). Skipped \(skipped) duplicate(s).")
    }
}
