//
//  RestTimerPickerView.swift
//  Fit 2
//
//  Created by Gopal Patel on 4/11/25.
//

import UIKit

class RestTimerPickerView: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var nameLabel: UILabel!
    //var times: [Int] = []
    
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func configure() {
        
        nameLabel.text = exercise!.name
        let duration = exercise!.restTimer
        
        if (duration == 0) {
            pickerView.selectRow(0, inComponent: 0, animated: false)
        } else {
            let row = duration/15
            pickerView.selectRow(Int(row), inComponent: 0, animated: false)
        }
        
    }

    @IBAction func donePressed(_ sender: UIButton) {
        print(exercise!.restTimer)
        self.dismiss(animated: true)
    }
}

extension RestTimerPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 21
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (row == 0) {
            exercise?.restTimer = 0
            return "No timer"
        }
        
        let duration = row * 15
        let minutes = duration/60
        let seconds = duration%60
        
        if (minutes == 0) {
            return "\(seconds)s"
        } else {
            return "\(minutes)min \(seconds)s"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let duration = row * 15
        exercise?.restTimer = Int64(duration)
    }
    
    
}
