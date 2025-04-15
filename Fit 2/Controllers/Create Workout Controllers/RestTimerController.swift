//
//  RestTimerController.swift
//  Fit 2
//
//  Created by Gopal Patel on 4/11/25.
//
import UIKit

class RestTimerController: UIViewController {
    
    @IBOutlet weak var circularProgressView: CircularProgressView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var startTimerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindToRestTimer()
        updateStartButtonTitle()
    }

    func configureUI() {
        circularProgressView.setProgressColor = UIColor(red: 50/255, green: 168/255, blue: 82/255, alpha: 1.0)
        circularProgressView.setTrackColor = UIColor(red: 205/255, green: 247/255, blue: 212/255, alpha: 1.0)
        startTimerButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        updateLabels()
        updateProgressBar()
    }

    func bindToRestTimer() {
        let manager = RestTimerManager.shared

        manager.onTick = { [weak self] _ in
            self?.updateLabels()
            self?.updateProgressBar()
            self?.updateStartButtonTitle()
        }

        manager.onTimerComplete = { [weak self] in
            self?.updateLabels()
            self?.animateResetCircle()
            self?.updateStartButtonTitle()
        }
    }

    @IBAction func startTimerPressed(_ sender: UIButton) {
        let manager = RestTimerManager.shared
        
        if manager.isRunning() {
            manager.reset()
            updateLabels()
            updateProgressBar()
            updateStartButtonTitle()
            animateResetCircle()
        } else {
            manager.startTimer()
            updateStartButtonTitle()
        }
    }
    
    func updateStartButtonTitle() {
        let isRunning = RestTimerManager.shared.isRunning()
        startTimerButton.setTitle(isRunning ? "Cancel Timer" : "Start Workout Timer", for: .normal)
        if (isRunning) {
            startTimerButton.backgroundColor = .quaternarySystemFill
        } else {
            startTimerButton.backgroundColor = .link
        }
    }



    @IBAction func plus10Pressed(_ sender: UIButton) {
        RestTimerManager.shared.adjustTime(by: 10)
        updateLabels()
    }

    @IBAction func minus10Pressed(_ sender: UIButton) {
        RestTimerManager.shared.adjustTime(by: -10)
        updateLabels()
    }

    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    func updateLabels() {
        let manager = RestTimerManager.shared
        let remaining = manager.remainingTime
        let total = manager.totalTime

        let min = Int(remaining) / 60
        let sec = Int(remaining) % 60
        timeLabel.text = String(format: "%01d:%02d", min, sec)

        let minTotal = Int(total) / 60
        let secTotal = Int(total) % 60
        totalTimeLabel.text = String(format: "%01d:%02d", minTotal, secTotal)
        updateStartButtonTitle()
    }

    func updateProgressBar() {
        let manager = RestTimerManager.shared
        let progress = manager.totalTime == 0 ? 0 : Float(manager.remainingTime / manager.totalTime)
        circularProgressView.setProgressDirectly(progress)
    }

    func animateResetCircle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.circularProgressView.setProgressWithAnimation(duration: 1.0, from: 0.0, to: 1.0)
        }
    }
}
