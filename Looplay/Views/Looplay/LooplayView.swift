//
//  Looplay.swift
//  Looplay
//
//  Created by Amadou on 10.07.2025.
//

import SwiftUI
import SwiftData

struct LooplayView: View {
    // MARK: – Data
    @Query(sort: \Song.createdDate) private var songs: [Song]
    
    // MARK: – Random-picker state
    @State private var queue = LooplayManager<Song>(items: [])
    @State private var currentSong: Song? = nil
    
    // MARK: – Timer state
    @StateObject private var timerManager = TimerManager(
        totalDuration: TimeInterval(PracticeDuration.thirtySeconds.rawValue)
    )
    
    // MARK: – Duration picker
    @State private var selectedDuration: PracticeDuration = .thirtySeconds
    @State private var showDurationPicker = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Remaining / Total
                HStack {
                    Text("Remaining: \(queue.remainingCount)")
                    Spacer()
                    Text("Total: \(queue.totalCount)")
                }
                .padding(.horizontal)
                
                // Current song display
                SongInfoView(currentSong: $currentSong)
                
                VStack {
                    Text("Next:")
                    Text(queue.peek?.title ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                        .frame(height: 20)
                }.opacity(timerManager.isInFinalSeconds ? 1 : 0)
                
                TimerRingView(timerManager: timerManager)
                
                PlaybackControlsView(
                    currentSong: $currentSong,
                    queue: $queue,
                    timerManager: timerManager,
                    songs: songs
                )
                
                Spacer(minLength: 20)
                
                // Duration picker row
                DurationPickerButton(
                    selectedDuration: $selectedDuration,
                    showPicker: $showDurationPicker
                )
            }
            .navigationTitle("Looplay")
            .navigationBarTitleDisplayMode(.large)
            .onChange(of: selectedDuration) { _, newValue in
                timerManager.reset(to: TimeInterval(newValue.rawValue))
            }
            .sheet(isPresented: $showDurationPicker) {
                DurationPickerView(
                    options: PracticeDuration.allCases,
                    selected: $selectedDuration
                )
            }
        }
        .onAppear {
          timerManager.onComplete = {
            advanceOrFinish()
          }
        }
    }
    
    /// Advance to the next song, or finish the session.
    private func advanceOrFinish() {
        if let nextSong = queue.next() {
            currentSong = nextSong

            timerManager.stop()
            timerManager.start()
        } else {
            endSession()
        }
    }

    /// Completely reset everything to the idle state.
    private func endSession() {
        timerManager.stop()
        currentSong = nil
        queue = LooplayManager(items: songs)
    }
}

#Preview {
    LooplayView()
}
