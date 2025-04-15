//
//  WorkoutTimerManager.swift
//  Fit 2
//
//  Created by Gopal Patel on 4/11/25.
//

import Foundation

class WorkoutTimerManager {
    static let shared = WorkoutTimerManager()

    private var timer: Timer?
    private(set) var elapsedTime: TimeInterval = 0
    var isRunning: Bool { timer != nil }

    // Callbacks for UI updates
    var onTick: ((TimeInterval) -> Void)?
    var onStop: ((TimeInterval) -> Void)?

    private init() {}

    func start() {
        guard timer == nil else { return }

        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime += 1
            self.onTick?(self.elapsedTime)
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        onStop?(elapsedTime)
    }

    func reset() {
        stop()
        elapsedTime = 0
    }

    func formattedTime() -> String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60

        return hours > 0
            ? String(format: "%d:%02d:%02d", hours, minutes, seconds)
            : String(format: "%d:%02d", minutes, seconds)
    }

}

