//
//  SongsListNavigationLink.swift
//  Looplay
//
//  Created by Amadou on 18.07.2025.
//

import SwiftUI

struct SongsListNavigationLink: View {
    let list: SongsList
    
    var body: some View {
        NavigationLink {
            SongsInListView(songsList: list)
        } label: {
            HStack {
                Text(list.name)
                Spacer()
                Text(list.songs.count.description)
                    .font(.subheadline)
            }
        }
    }
}
