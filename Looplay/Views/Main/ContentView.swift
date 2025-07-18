//
//  ContentView.swift
//  Looplay
//
//  Created by Amadou on 09.07.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var createNewSong : Bool = false
    
    @Query(filter: #Predicate { $0.mastery == 0 }, sort: \Song.title)
    private var songsToLearn: [Song]

    @Query(filter: #Predicate { $0.mastery >= 1 }, sort: \Song.title)
    private var repertoireSongs: [Song]
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Lists")) {
                    SongNavigationLink(list: repertoireSongs, title: "Repertoire")
                    SongNavigationLink(list: songsToLearn, title: "Learning queue")
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
                    
                    /*

                    Button("Add List") {
                        print("Pressed")
                    }
                    */
                }
            }
            .sheet(isPresented: $createNewSong) {
                NewSongView().presentationDetents([.medium])
            }
        }
    }
}
