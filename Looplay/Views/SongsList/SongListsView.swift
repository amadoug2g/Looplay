//
//  SongListsView.swift
//  Looplay
//
//  Created by Amadou on 18.07.2025.
//

import SwiftUI
import SwiftData

struct SongListsView: View {
    @Query(sort: \SongsList.createdDate) var songLists: [SongsList]
    @Environment(\.modelContext) private var context
    @State private var showingNewListForm = false

    var body: some View {
        List {
            ForEach(songLists) { list in
                NavigationLink(list.name) {
                    SongsInListView(songsList: list)
                }
            }
            .onDelete(perform: deleteLists)
        }
        .navigationTitle("Song Lists")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("1", systemImage: "plus") {
                    showingNewListForm = true
                }
            }
        }
        .sheet(isPresented: $showingNewListForm) {
            NewSongListView()
        }
    }

    func deleteLists(at offsets: IndexSet) {
        for index in offsets {
            context.delete(songLists[index])
        }
    }
}
