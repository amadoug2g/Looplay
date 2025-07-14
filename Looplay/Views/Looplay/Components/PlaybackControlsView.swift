//
//  PlaybackControlsView.swift
//  Looplay
//
//  Created by Amadou on 13.07.2025.
//

import SwiftUI

struct PlaybackControlsView: View {
    @Binding var currentSong: Song?
    @Binding var queue: LooplayManager<Song>
    @ObservedObject var timerManager: TimerManager
    var songs: [Song]

    var body: some View {
        HStack(spacing: 40) {
            Button("Stop") {
                timerManager.stop()
                currentSong = nil
                queue = LooplayManager(items: songs)
            }
            .frame(width: 80, height: 80)
            .background(Circle().fill(Color.red.opacity(0.3)))
            .disabled(!timerManager.isRunning)

            Button(timerManager.isRunning ? "Running" : "Start") {
                if !timerManager.isRunning {
                    if queue.remainingCount == queue.totalCount {
                        queue = LooplayManager(items: songs)
                    }
                    if let first = queue.next() {
                        currentSong = first
                        timerManager.start()
                    }
                }
            }
            .frame(width: 80, height: 80)
            .background(Circle().fill(Color.cyan.opacity(0.4)))
            .foregroundColor(.primary)
        }
    }
}
