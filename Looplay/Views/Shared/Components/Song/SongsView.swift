//
//  SongList.swift
//  Looplay
//
//  Created by Amadou on 15.07.2025.
//

import SwiftUI

struct SongsView: View {
    @Environment(\.modelContext) private var context
    let songs: [Song]
    let title: String

    var body: some View {
        VStack(spacing: 16) {
            if songs.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No songs yet")
                        .font(.headline)
                    Text("Tap \u{201C}New Song\u{201D} to add your first track.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                Spacer()
            } else {
                NavigationLink {
                    LooplayView(songs: songs)
                } label: {
                    Label("Shuffle", systemImage: "shuffle")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12).fill(Color.blue)
                        )
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Shuffle \(songs.count) songs")
                .accessibilityHint("Starts a randomized practice session")

                List {
                    ForEach(songs) { song in
                        NavigationLink {
                            EditSongView(song: song)
                        } label: {
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
                        .accessibilityLabel("\(song.title) by \(song.artist), mastery \(song.mastery) out of 5")
                    }
                    .onDelete(perform: deleteSongs)
                }
            }
        }
        .navigationTitle(title)
    }

    private func deleteSongs(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(songs[index])
            }
            do {
                try context.save()
            } catch {
                print("SongsView: failed to save after delete – \(error)")
            }
        }
    }
}
