//
//  ContentView.swift
//  Looplay
//
//  Created by Amadou on 09.07.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var createNewSong = false
    @State private var createNewList = false

    @Query(filter: #Predicate { $0.mastery == 0 }, sort: \Song.title)
    private var songsToLearn: [Song]

    @Query(filter: #Predicate { $0.mastery >= 1 }, sort: \Song.title)
    private var repertoireSongs: [Song]

    @Query(sort: \SongsList.name)
    private var songLists: [SongsList]

    private var allSongs: [Song] { repertoireSongs + songsToLearn }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    SongNavigationLink(list: repertoireSongs, title: "Repertoire")
                    SongNavigationLink(list: songsToLearn, title: "Learning queue")
                }

                Section(header: Text("My Lists")) {
                    if songLists.isEmpty {
                        Text("No lists yet. Tap "New List" to create one.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(songLists) { list in
                            SongsListNavigationLink(list: list)
                        }
                    }
                }
            }
            .overlay {
                if allSongs.isEmpty && songLists.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "music.note")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("Your library is empty")
                            .font(.title2.bold())
                        Text("Tap "New Song" below to start building your practice library.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
            }
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

                    Button {
                        createNewList = true
                    } label: {
                        Text("New List")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $createNewSong) {
                NewSongView().presentationDetents([.large])
            }
            .sheet(isPresented: $createNewList) {
                NewSongListView().presentationDetents([.large])
            }
        }
    }
}
