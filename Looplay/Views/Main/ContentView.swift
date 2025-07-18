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

    var body: some View {
        NavigationStack {
            List {
                Section {
                    SongNavigationLink(list: repertoireSongs, title: "Repertoire")
                    SongNavigationLink(list: songsToLearn, title: "Learning queue")
                }

                Section(header: Text("My Lists")) {
                    ForEach(songLists) { list in
                        SongsListNavigationLink(list: list)
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
