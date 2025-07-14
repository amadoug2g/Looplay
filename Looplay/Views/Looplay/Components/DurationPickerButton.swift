//
//  DurationPickerButton.swift
//  Looplay
//
//  Created by Amadou on 13.07.2025.
//

import SwiftUI

struct DurationPickerButton: View {
    @Binding var selectedDuration: PracticeDuration
    @Binding var showPicker: Bool

    var body: some View {
        Button {
            showPicker = true
        } label: {
            HStack {
                Text("Duration")
                Spacer()
                Text(selectedDuration.displayName)
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(UIColor.secondarySystemFill))
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }
}
