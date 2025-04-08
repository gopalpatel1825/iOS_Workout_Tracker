//
//  ExerciseRecordTableViewCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/27/25.
//

import UIKit

class ExerciseRecordTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var PRLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var set: Set?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setDateLabel() {
        let date = set!.exercise!.workout!.startDate
        dateLabel.text = date?.formatted(date: .abbreviated, time: .shortened)
    }

    
    func configureFor1RM() {
        PRLabel.text = "\(set?.oneRepMax ?? 0)lbs"
    }
    
    func configureForVolume() {
        PRLabel.text = "\(set?.weight ?? 0)lbs x \(set?.reps ?? 0)"
    }
    
    func configureForWeight() {
        PRLabel.text = "\(set?.weight ?? 0)lbs"
    }
    
    
}
