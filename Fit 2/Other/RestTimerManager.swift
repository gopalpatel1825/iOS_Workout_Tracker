//
//  RestTimerManager.swift
//  Fit 2
//
//  Created by Gopal Patel on 4/11/25.
//

import UIKit

class RestTimerManager {
    
    static let shared = RestTimerManager()
    
    private var timer: Timer?
    private(set) var totalTime: TimeInterval = 150
    private(set) var remainingTime: TimeInterval = 150
    private var timerRunning = false
    
    var onTick: ((TimeInterval) -> Void)?
    var onTimerComplete: (() -> Void)?
    
    private init() {}
    
    func startTimer(total: TimeInterval = 150) {
        guard !timerRunning else { return }
        self.totalTime = total
        self.remainingTime = total
        self.timerRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.remainingTime -= 1
            self.onTick?(self.remainingTime)
            
            if self.remainingTime <= 0 {
                self.timer?.invalidate()
                self.timer = nil
                self.timerRunning = false
                self.remainingTime = 0
                self.onTimerComplete?()
            }
        }
    }
    
    func adjustTime(by delta: TimeInterval) {
        if timerRunning {
            remainingTime = max(0, remainingTime + delta)
            totalTime = max(0, totalTime + delta)
            onTick?(remainingTime)
        }
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        remainingTime = totalTime
        timerRunning = false
    }
    
    func isRunning() -> Bool {
        return timerRunning
    }
}
