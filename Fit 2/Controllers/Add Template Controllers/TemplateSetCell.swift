//
//  ExerciseCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/3/25.
//

import UIKit

class TemplateSetCell: UITableViewCell, UITextFieldDelegate {
    
    var set: Set?
    lazy var setNumber = (set!.index)

    @IBOutlet weak var numberOfSetsLabel: UILabel!
    @IBOutlet weak var previousPerformanceLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        weightTextField.delegate = self
        repsTextField.delegate = self
        
        weightTextField.text = ("\(set?.weight ?? 0)")
        repsTextField.text = ("\(set?.reps ?? 0)")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure() {
        weightTextField.text = (set?.weight ?? 0) > 0 ? "\(set?.weight ?? 0)" : ""
        repsTextField.text = (set?.reps ?? 0) > 0 ? "\(set?.reps ?? 0)" : ""
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
    }
    
    func setIndex() {
        self.set!.index = setNumber
    }
}
