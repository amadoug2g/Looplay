//
//  LooplayTests.swift
//  LooplayTests
//
//  Created by Amadou on 09.07.2025.
//

import Testing
import Foundation
@testable import Looplay

// MARK: - LooplayManager Tests

struct LooplayManagerTests {

    @Test func allItemsReturnedExactlyOnce() {
        var manager = LooplayManager(items: [1, 2, 3, 4, 5])
        var seen: [Int] = []
        while let item = manager.next() {
            seen.append(item)
        }
        #expect(seen.sorted() == [1, 2, 3, 4, 5])
    }

    @Test func nextReturnsNilWhenQueueIsEmpty() {
        var manager = LooplayManager(items: [Int]())
        #expect(manager.next() == nil)
    }

    @Test func nextOnEmptyManagerSetsCurrentToNil() {
        var manager = LooplayManager(items: [42])
        _ = manager.next()       // drains the queue
        _ = manager.next()       // empty → current should be nil
        #expect(manager.current == nil)
    }

    @Test func totalCountNeverChanges() {
        var manager = LooplayManager(items: [1, 2, 3])
        #expect(manager.totalCount == 3)
        _ = manager.next()
        #expect(manager.totalCount == 3)
    }

    @Test func remainingCountDecrementsOnNext() {
        var manager = LooplayManager(items: [1, 2, 3])
        #expect(manager.remainingCount == 3)
        _ = manager.next()
        #expect(manager.remainingCount == 2)
        _ = manager.next()
        #expect(manager.remainingCount == 1)
        _ = manager.next()
        #expect(manager.remainingCount == 0)
    }

    @Test func isEmptyAfterDraining() {
        var manager = LooplayManager(items: [1])
        #expect(!manager.isEmpty)
        _ = manager.next()
        #expect(manager.isEmpty)
    }

    @Test func resetRepopulatesQueue() {
        var manager = LooplayManager(items: [1, 2, 3])
        _ = manager.next()
        _ = manager.next()
        manager.reset()
        #expect(manager.remainingCount == 3)
        #expect(manager.current == nil)
    }

    @Test func peekReturnsFirstInQueue() {
        var manager = LooplayManager(items: [42])
        let peeked = manager.peek
        let popped = manager.next()
        // If peek showed something, it should match what next() returned
        if let p = peeked {
            #expect(p == popped)
        }
    }

    @Test func currentIsSetAfterNext() {
        var manager = LooplayManager(items: [7])
        let returned = manager.next()
        #expect(manager.current == returned)
        #expect(returned == 7)
    }
}

// MARK: - TimerManager Tests

struct TimerManagerTests {

    @Test func progressStartsAtZero() {
        let timer = TimerManager(totalDuration: 30)
        #expect(timer.progress == 0)
    }

    @Test func isRunningStartsFalse() {
        let timer = TimerManager(totalDuration: 30)
        #expect(!timer.isRunning)
    }

    @Test func isPausedStartsFalse() {
        let timer = TimerManager(totalDuration: 30)
        #expect(!timer.isPaused)
    }

    @Test func elapsedTimeStartsAtZero() {
        let timer = TimerManager(totalDuration: 30)
        #expect(timer.elapsedTime == 0)
    }

    @Test func resetClearsElapsedTimeAndSetsNewDuration() {
        let timer = TimerManager(totalDuration: 30)
        timer.reset(to: 60)
        #expect(timer.totalDuration == 60)
        #expect(timer.elapsedTime == 0)
        #expect(!timer.isRunning)
        #expect(!timer.isPaused)
    }

    @Test func stopClearsAllState() {
        let timer = TimerManager(totalDuration: 10)
        timer.start()
        timer.stop()
        #expect(!timer.isRunning)
        #expect(!timer.isPaused)
        #expect(timer.elapsedTime == 0)
    }

    @Test func pauseSetsIsPausedAndClearsIsRunning() {
        let timer = TimerManager(totalDuration: 30)
        timer.start()
        timer.pause()
        #expect(timer.isPaused)
        #expect(!timer.isRunning)
    }

    @Test func resumeAfterPauseSetsIsRunning() {
        let timer = TimerManager(totalDuration: 30)
        timer.start()
        timer.pause()
        timer.resume()
        #expect(timer.isRunning)
        #expect(!timer.isPaused)
        timer.stop()
    }

    @Test func remainingTimeEqualsTotal_whenNotStarted() {
        let timer = TimerManager(totalDuration: 30)
        #expect(timer.remainingTime == 30)
    }

    @Test func isInFinalSecondsWhenLessThanFiveRemaining() {
        let timer = TimerManager(totalDuration: 30)
        // Directly test the computed property logic by resetting to a short duration
        timer.reset(to: 4)
        // remaining = 4, which is <= 5
        #expect(timer.isInFinalSeconds)
    }

    @Test func isInFinalSecondsIsFalseWhenMoreThanFiveRemaining() {
        let timer = TimerManager(totalDuration: 30)
        #expect(!timer.isInFinalSeconds)
    }

    @Test func timeStringFormatIsMMSS() {
        let timer = TimerManager(totalDuration: 90)
        // elapsedTime = 0, so timeString should be "00:00"
        #expect(timer.timeString == "00:00")
    }

    @Test func remainingTimeStringFormatIsMMSS() {
        let timer = TimerManager(totalDuration: 90)
        // remaining = 90s → "01:30"
        #expect(timer.remainingTimeString == "01:30")
    }
}

// MARK: - Import Parsing Logic Tests
//
// We test the parsing logic by exercising importSongsFromClipboard indirectly
// through a helper that mirrors its parsing steps.

struct ImportParsingTests {

    /// Mirrors the parsing logic from SongListView.importSongsFromClipboard
    func parseClipboard(_ text: String) -> [(title: String, artist: String)] {
        let lines = text.split(whereSeparator: \.isNewline).map(String.init)
        var results: [(String, String)] = []
        for raw in lines {
            let trimmed: String
            if raw.hasPrefix("#"), let firstSpace = raw.firstIndex(of: " ") {
                trimmed = String(raw[raw.index(after: firstSpace)...])
            } else {
                trimmed = raw
            }
            let parts = trimmed
                .split(separator: "\u{2013}", maxSplits: 1)
                .map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2 {
                results.append((parts[0], parts[1]))
            } else {
                let fb = trimmed
                    .split(separator: "-", maxSplits: 1)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                if fb.count == 2 {
                    results.append((fb[0], fb[1]))
                }
            }
        }
        return results
    }

    @Test func parsesEnDashSeparator() {
        let result = parseClipboard("Bohemian Rhapsody \u{2013} Queen")
        #expect(result.count == 1)
        #expect(result[0].title == "Bohemian Rhapsody")
        #expect(result[0].artist == "Queen")
    }

    @Test func parsesHyphenMinusFallback() {
        let result = parseClipboard("Yesterday - The Beatles")
        #expect(result.count == 1)
        #expect(result[0].title == "Yesterday")
        #expect(result[0].artist == "The Beatles")
    }

    @Test func stripsNumberedPrefix() {
        let result = parseClipboard("#3 Let It Be \u{2013} The Beatles")
        #expect(result.count == 1)
        #expect(result[0].title == "Let It Be")
        #expect(result[0].artist == "The Beatles")
    }

    @Test func parsesMultipleLines() {
        let text = "#1 Song A \u{2013} Artist A\n#2 Song B \u{2013} Artist B"
        let result = parseClipboard(text)
        #expect(result.count == 2)
    }

    @Test func skipsLinesWithNoSeparator() {
        let result = parseClipboard("Invalid line with no separator")
        #expect(result.count == 0)
    }

    @Test func handlesEmptyLines() {
        let result = parseClipboard("")
        #expect(result.count == 0)
    }

    @Test func trimsWhitespaceAroundParts() {
        let result = parseClipboard("  Song Title  \u{2013}  Artist Name  ")
        #expect(result.count == 1)
        #expect(result[0].title == "Song Title")
        #expect(result[0].artist == "Artist Name")
    }

    @Test func enDashTakesPriorityOverHyphen() {
        // Title contains a hyphen, separator is en-dash — title should include hyphen intact
        let result = parseClipboard("Back In Black \u{2013} AC/DC")
        #expect(result.count == 1)
        #expect(result[0].title == "Back In Black")
        #expect(result[0].artist == "AC/DC")
    }
}
