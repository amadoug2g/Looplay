//
//  ListRow.swift
//  Looplay
//
//  Created by Amadou on 17.07.2025.
//

import SwiftUI

struct CustomListRow: View {
    let songsList: SongsList
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(songsList.name)
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
}
