//
//  Untitled.swift
//  Looplay
//
//  Created by Amadou on 16.07.2025.
//

import SwiftUI

struct MainContent: View {
    var body: some View {
        List {
            HStack {
                Section {
                    Button(action: {
                        print("Tapped")
                    }) {
                        Text("Click Me")
                            .padding()
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.green)
                            )
                    }

                }.frame(height: 60)
            }

            Text("Hello, World 1!")
            Text("Hello, World 2!")
            Text("Hello, World 3!")
        }
    }
}

#Preview {
    MainContent()
}
