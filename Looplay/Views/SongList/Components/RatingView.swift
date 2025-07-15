//
//  RatingView.swift
//  Looplay
//
//  Created by Amadou on 15.07.2025.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
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
                    rating = number
                } label: {
                    image(for: number)
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
            }
        }.buttonStyle(.plain)
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            offImage
        } else {
            onImage
        }
    }
}

#Preview {
    RatingView(rating: .constant(4))
}
