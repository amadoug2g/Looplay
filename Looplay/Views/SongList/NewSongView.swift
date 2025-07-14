//
//  AddSongView.swift
//  Looplay
//
//  Created by Amadou on 09.07.2025.
//

import SwiftUI
import SwiftData

struct NewSongView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var artist = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Song Title", text: $title)
                TextField("Artist", text: $artist)
                Button("Create") {
                    let newSong = Song(title: title, artist: artist)
                    context.insert(newSong)
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(title.isEmpty || artist.isEmpty)
                .navigationTitle("New Song")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    NewSongView()
}


 
