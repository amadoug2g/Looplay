//
//  SongNavigationLink.swift
//  Looplay
//
//  Created by Amadou on 17.07.2025.
//

import SwiftUI

struct SongNavigationLink: View {
    let list: [Song]
    let title: String
    
    var body: some View {
        NavigationLink {
            SongListView(title: title, songs: list)
        } label: {
            HStack {
                Text(title)
                Spacer()
                Text(list.count.description)
                    .font(.subheadline)
            }
            .padding(.vertical, 4)
        }
    }
}
