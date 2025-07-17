//
//  ListRow.swift
//  Looplay
//
//  Created by Amadou on 17.07.2025.
//

import SwiftUI

struct DefaultListRow: View {
    let title: String
    let songCount: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(songCount)
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}
