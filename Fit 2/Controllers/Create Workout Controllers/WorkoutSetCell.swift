//
//  WorkoutSetCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/26/25.
//

import UIKit

class WorkoutSetCell: UITableViewCell, UITextFieldDelegate {
    
    
    @IBOutlet weak var setNumberLabel: UILabel!
    
    @IBOutlet weak var previousPerformanceLabel: UILabel!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var repsTextField: UITextField!
    
    @IBOutlet weak var setCompletedButton: UIButton!

    
    
    
    var set: Set?
    lazy var setNumber = (set!.index)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        weightTextField.delegate = self
        repsTextField.delegate = self
        
    }

    
    @IBAction func completedPressed(_ sender: UIButton) {
        if (set?.completed == false || set?.completed == nil) {
            setSelected()
        } else {
            setUnselected()
        }
        
        self.set!.modified = true
    }
    
    func configure() {
        // Set the text place holders
        let preWeight = set?.previousWeight ?? 0
        let preReps = set?.previousReps ?? 0
        weightTextField.placeholder = (preWeight) >= 0 ? "\(preWeight)" : "-"
        repsTextField.placeholder = (preReps) >= 0 ? "\(preReps)" : "-"
        
        // Set the textfields if the set has weight or reps
        if (self.set!.weight != 0) {
            weightTextField.text = "\(self.set!.weight)"
        }
        
        if (self.set!.reps != 0) {
            repsTextField.text = "\(self.set!.reps)"
        }
        
        if ((set?.completed) != nil && (set?.completed) != false) {
            setSelected()
        }  else {
            setUnselected()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == weightTextField {
            let weight = Double(textField.text ?? "") ?? 0
            if weight >= 0 {
                set?.weight = weight
            }
            
        } else if textField == repsTextField {
            let reps = Int64(textField.text ?? "") ?? 0
            if reps > 0 {
                set?.reps = reps
            }
        }
        
        self.set!.modified = true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == "" {
            setUnselected()
        }
        
        if textField == weightTextField {
            let weight = Double(textField.text ?? "") ?? 0
            if weight >= 0 {
                set?.weight = weight
            }
            
        } else if textField == repsTextField {
            let reps = Int64(textField.text ?? "") ?? 0
            if reps > 0 {
                set?.reps = reps
            }
        }
        
        self.set!.modified = true
    }
    
    
    
    func setSelected() {
        self.set!.completed = true
        self.contentView.backgroundColor = UIColor(named: "SetSelectedBackground")
        setCompletedButton.tintColor = UIColor(named: "SetSelected")
        if (repsTextField.text == "") {
            repsTextField.text = repsTextField.placeholder
            self.set!.reps = self.set!.previousReps ?? 0
        }
        
        if (weightTextField.text == "") {
            weightTextField.text = weightTextField.placeholder
            self.set!.weight = self.set!.previousWeight ?? 0
        }
    }
    
    func setUnselected() {
        self.contentView.backgroundColor = .secondarySystemBackground
        setCompletedButton.tintColor = .opaqueSeparator
        self.set!.completed = false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            // Get current text after change
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }

            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            // Limit to 5 characters
            return updatedText.count <= 5
        }
}
