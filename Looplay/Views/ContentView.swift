//
//  ContentView.swift
//  Looplay
//
//  Created by Amadou on 09.07.2025.
//

import SwiftUI

struct ContentView: View {
    enum Tabs {
        case songs, looplay
    }
    
    @State private var selection: Tabs = .songs
    var body: some View {
        TabView(selection: $selection) {
            Tab("Songs", systemImage: "music.note.list", value: .songs) {
                SongListView()
            }
            Tab("Looplay", systemImage: "shuffle", value: .looplay) {
                LooplayView()
            }
        }
    }
}


#Preview {
    ContentView()
}

