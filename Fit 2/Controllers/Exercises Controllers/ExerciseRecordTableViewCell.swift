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
    
    var set: Set? { didSet {setDateLabel()}}
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setDateLabel() {
        let date = set!.exercise!.workout!.startDate
        dateLabel.text = date?.formatted(date: .abbreviated, time: .omitted)
    }

    
    func configureFor1RM() {
        PRLabel.text = String(format: "%.0flbs", set?.oneRepMax ?? 0)
    }
    
    func configureForVolume() {
        PRLabel.text = String(format: "%.0flbs", set?.volume ?? 0)
    }
    
    func configureForWeight() {
        PRLabel.text = String(format: "%0.1flbs", set?.weight ?? 0)
    }
    
    
}
