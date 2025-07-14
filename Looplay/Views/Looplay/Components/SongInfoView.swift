//
//  SongInfoView.swift
//  Looplay
//
//  Created by Amadou on 13.07.2025.
//

import SwiftUI

struct SongInfoView: View {
    @Binding var currentSong: Song?

    var body: some View {
        VStack(spacing: 4) {
            Text(currentSong?.title ?? "")
                .font(.title2).fontWeight(.semibold)
            Text(currentSong?.artist ?? "")
                .font(.subheadline).foregroundColor(.gray)
        }
        .frame(height: 40)
        .padding(.bottom, 20)
        .opacity(currentSong == nil ? 0 : 1)
    }
}

