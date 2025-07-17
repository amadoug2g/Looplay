//
//  TileView.swift
//  Looplay
//
//  Created by Amadou on 16.07.2025.
//

import SwiftUI

struct TileView: View {
    let icon: Image
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray6))
            .frame(height: 100)
            .overlay(
                
                VStack(alignment: .leading) {
                    HStack {
                        icon
                            .resizable()
                            .frame(width: 20, height: 24)
                            .padding(12)
                            .background(color)
                            .clipShape(Circle())
                        Spacer()
                        Text("\(count)")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                    }
                    .padding()
                    
                        Text(title)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(04)
                }
                
            )
    }
}

#Preview {
    TileView(
        icon: Image(systemName: "music.note"), title: "Title", count: 1, color: Color.red
    )
}
