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
        HStack(spacing: 30) {
            // Stop – resets everything
            Button("Stop") {
                timerManager.stop()
                currentSong = nil
                queue = LooplayManager(items: songs)
            }
            .frame(width: 80, height: 80)
            .background(
                Circle().fill(Color.red.opacity(timerManager.isRunning || timerManager.isPaused ? 1 : 0.35))
            )
            .disabled(!timerManager.isRunning && !timerManager.isPaused)
            .accessibilityLabel("Stop session")
            .accessibilityHint("Stops the timer and resets to the beginning")

            // Pause / Resume – only visible during an active session
            if timerManager.isRunning || timerManager.isPaused {
                Button(timerManager.isPaused ? "Resume" : "Pause") {
                    if timerManager.isPaused {
                        timerManager.resume()
                    } else {
                        timerManager.pause()
                    }
                }
                .frame(width: 80, height: 80)
                .background(Circle().fill(Color.orange.opacity(0.7)))
                .foregroundColor(.primary)
                .accessibilityLabel(timerManager.isPaused ? "Resume timer" : "Pause timer")
            }

            // Start / Next
            Button(timerManager.isRunning ? "Next" : "Start") {
                if timerManager.isRunning {
                    // Skip to next song immediately
                    timerManager.stop()
                    if let nextSong = queue.next() {
                        currentSong = nextSong
                        timerManager.start()
                    } else {
                        currentSong = nil
                        queue = LooplayManager(items: songs)
                    }
                } else if timerManager.isPaused {
                    // Do nothing – user should Resume or Stop
                } else {
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
            .background(Circle().fill(Color.cyan.opacity(timerManager.isPaused ? 0.2 : 0.4)))
            .foregroundColor(.primary)
            .disabled(timerManager.isPaused)
            .accessibilityLabel(timerManager.isRunning ? "Skip to next song" : "Start session")
            .accessibilityHint(timerManager.isRunning ? "Advances to the next song immediately" : "Starts the randomized practice session")
        }
    }
}
