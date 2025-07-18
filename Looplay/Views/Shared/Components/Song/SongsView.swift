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
            NavigationStack {
                VStack(spacing: 16) {
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
                        }
                        .onDelete(perform: deleteSongs)
                    }
                }
                .navigationTitle(title)
            }
        }
    
    private func deleteSongs(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let song = songs[index]
                context.delete(song)
            }
            try? context.save()
        }
    }
}
