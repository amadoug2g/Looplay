//
//  RatingView.swift
//  Looplay
//
//  Created by Amadou on 15.07.2025.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    var showHint = false
    
    var label = ""
    var maxRating = 5
    
    var onImage = Image(systemName: "star.fill")
    var offImage = Image(systemName: "star")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1...maxRating, id: \.self) { number in
                Button {
                    if rating == 1 && number == 1 {
                        rating = 0
                    } else {
                        rating = number
                    }
                } label: {
                    image(for: number)
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
            }
        }.buttonStyle(.plain)
        
        if showHint && rating == 1 {
            Text("Tap the first star again to reset to 0")
                .font(.caption)
                .foregroundColor(.secondary)
        }

    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            offImage
        } else {
            onImage
        }
    }
}
