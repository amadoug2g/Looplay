//
//  TimerRingView.swift
//  Looplay
//
//  Created by Amadou on 13.07.2025.
//

import SwiftUI

struct TimerRingView: View {
    @ObservedObject var timerManager: TimerManager

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: timerManager.progress)
                .rotation(.degrees(-90))
                .stroke(
                    Color.cyan.opacity(0.4),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 220, height: 220)

            Text(timerManager.timeString)
                .font(.system(size: 40, weight: .bold))
        }
    }
}
