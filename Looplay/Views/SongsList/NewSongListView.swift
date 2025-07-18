//
//  NewSongListView.swift
//  Looplay
//
//  Created by Amadou on 18.07.2025.
//

import SwiftUI
import SwiftData

struct NewSongListView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var description = ""

    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("List Name", text: $name)
                    .focused($isTitleFocused)
                TextField("Description", text: $description)
            }
            .navigationTitle("New List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let list = SongsList(name: name, description: description)
                        context.insert(list)
                        dismiss()
                    }.disabled(name.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                isTitleFocused = true
            }
        }
    }
}
