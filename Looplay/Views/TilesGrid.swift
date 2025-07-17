//
//  TilesGrid.swift
//  Looplay
//
//  Created by Amadou on 16.07.2025.
//

import SwiftUI

struct TilesGrid: View {
    let tiles = [
        ("Today", Image(systemName: "calendar.circle.fill"), 2, Color.blue),
        ("Scheduled", Image(systemName: "calendar.badge.clock"), 14, Color.red),
        ("Sport", Image(systemName: "figure.walk.circle"), 0, Color.blue.opacity(0.6)),
        ("Einkaufen", Image(systemName: "list.bullet.circle.fill"), 5, Color.pink)
    ]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(tiles, id: \.0) { title, icon, count, color in
                TileView(icon: icon, title: title, count: count, color: color)
            }
        }
        .padding()
    }
}

#Preview {
    TilesGrid()
}
