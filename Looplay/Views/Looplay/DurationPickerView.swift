//
//  DurationPickerView.swift
//  Looplay
//
//  Created by Amadou on 10.07.2025.
//

import SwiftUI

struct DurationPickerView: View {
    let options: [PracticeDuration]
    @Binding var selected: PracticeDuration
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(options) { option in
                HStack {
                    Text(option.displayName)
                    Spacer()
                    if option == selected {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selected = option
                    dismiss()
                }
            }
            .navigationTitle("Duration")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back") { dismiss() }
                }
            }
        }
    }
}
