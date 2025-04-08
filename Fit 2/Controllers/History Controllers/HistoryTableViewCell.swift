//
//  HistoryTableViewCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/4/25.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var letterLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bestSetLabel: UILabel!
    
    var exercise: WorkoutExercise?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure() {
        
        letterLabel.text = exercise?.exercise?.name?.first?.description ?? ""
        
        let name = exercise!.exercise?.name
        let count = exercise!.sets?.count
        
        nameLabel.text = "\(count!) x \(name!)"
        
        var max: Float = 0.0
        var reps: Int = 0
        var weight: Float = 0.0
        for aset in exercise?.sets?.array as! [Set] {
            let volume = Float(aset.volume)
            if (volume > max) {
                max = volume
                reps = Int(aset.reps)
                weight = Float(aset.weight)
            }
        }
        
        bestSetLabel.text = "Best Set: \(String(format: "%.1f", weight)) lbs x \(reps)"
        
    }
}
