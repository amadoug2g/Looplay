//
//  SongsInListView.swift
//  Looplay
//
//  Created by Amadou on 18.07.2025.
//

import SwiftUI

struct SongsInListView: View {
    @State private var showEditView = false
    let songsList: SongsList

    var body: some View {
        SongsView(songs: songsList.songs, title: songsList.name)
        .listStyle(.plain)
        .navigationTitle(songsList.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Edit") {
                showEditView = true
            }
        }
        .sheet(isPresented: $showEditView) {
            EditSongsListView(songsList: songsList)
        }
    }
}
