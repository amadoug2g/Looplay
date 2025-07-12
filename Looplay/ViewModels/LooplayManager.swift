//
//  LooplayManager.swift
//  Looplay
//
//  Created by Amadou on 10.07.2025.
//

import Foundation

/// Manages a one-time randomized queue of items.
struct LooplayManager<Item: Equatable> {
    private let allItems: [Item]
    private var queue: [Item]
    private(set) var current: Item?
    var onComplete: (() -> Void)?

    /// Number of items ever loaded
    var totalCount: Int { allItems.count }

    /// How many remain to be picked
    var remainingCount: Int { queue.count }

    /// Has every item been picked already?
    var isEmpty: Bool { queue.isEmpty }

    /// Initialize with a list of items; shuffles immediately.
    init(items: [Item]) {
        self.allItems = items
        self.queue = items.shuffled()
        self.current = nil
    }

    /// Reshuffle and reset the queue.
    mutating func reset() {
        queue = allItems.shuffled()
        current = nil
    }

    /// Pop the next item (in random order).
    /// Returns `nil` if the queue is empty.
    @discardableResult
    mutating func next() -> Item? {
        guard !queue.isEmpty else {
            current = nil
            return nil
        }
        current = queue.removeFirst()
        return current
    }
}
