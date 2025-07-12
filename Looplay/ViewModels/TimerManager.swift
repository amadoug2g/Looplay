//
//  TimerManager.swift
//  Looplay
//
//  Created by Amadou on 10.07.2025.
//

import Foundation
import Combine

/// Manages timer logic separately from the UI.
final class TimerManager: ObservableObject {
    @Published private(set) var elapsedTime: TimeInterval = 0
    @Published private(set) var isRunning: Bool = false

    /// Total duration for the timer
    private(set) var totalDuration: TimeInterval

    /// Cancellable for the Combine timer publisher
    private var timerCancellable: AnyCancellable?

    var onComplete: (() -> Void)?
    
    /// Initialize with a total duration (in seconds)
    init(totalDuration: TimeInterval) {
        self.totalDuration = totalDuration
    }

    /// Start or resume the timer
    func start() {
        guard !isRunning else { return }
        isRunning = true
        let startDate = Date().addingTimeInterval(-elapsedTime)

        timerCancellable = Timer
            .publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] now in
                guard let self = self, self.isRunning else { return }
                self.elapsedTime = now.timeIntervalSince(startDate)
                if self.elapsedTime >= self.totalDuration {
                    self.elapsedTime = self.totalDuration
                    self.stop()
                    
                    DispatchQueue.main.async {
                      self.onComplete?()
                    }
                }
            }
    }

    /// Pause the timer
    func pause() {
        guard isRunning else { return }
        isRunning = false
        timerCancellable?.cancel()
    }

    /// Stop and reset the timer
    func stop() {
        isRunning = false
        timerCancellable?.cancel()
        elapsedTime = 0
    }

    /// Reset to a new total duration and clear state
    func reset(to newDuration: TimeInterval) {
        stop()
        totalDuration = newDuration
    }

    /// Normalized progress [0.0…1.0]
    var progress: Double {
        guard totalDuration > 0 else { return 0 }
        return min(elapsedTime / totalDuration, 1)
    }

    /// Formatted time string MM:SS
    var timeString: String {
        let secs = Int(elapsedTime)
        let minutes = secs / 60
        let seconds = secs % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
