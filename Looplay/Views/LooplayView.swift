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
                
                Spacer()
                
                // Current song display
                if let song = currentSong {
                    VStack(spacing: 4) {
                        Text(song.title)
                            .font(.title2).fontWeight(.semibold)
                        Text(song.artist)
                            .font(.subheadline).foregroundColor(.gray)
                    }
                    .padding(.bottom, 20)
                }
                
                // Timer ring + label
                ZStack {
                    Circle()
                        .trim(from: 0, to: timerManager.progress)
                        .rotation(.degrees(-90))
                        .stroke(Color.cyan.opacity(0.4), lineWidth: 12)
                        .frame(width: 260, height: 260)
                    Text(timerManager.timeString)
                        .font(.system(size: 48, weight: .bold))
                }
                
                Spacer()
                
                // Controls: Stop / Start
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
                            // On first start (or after a reset), build & kick off
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
                
                Spacer(minLength: 20)
                
                // Duration picker row
                Button {
                    showDurationPicker = true
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
          // Every time the view appears, wire the timer’s completion to your handler:
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
