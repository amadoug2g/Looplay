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
                                SongRow(song: song)
                            }
                        }
                        .onDelete(perform: deleteSongs)
                    }
                }
                .navigationTitle("Repertoire")
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
