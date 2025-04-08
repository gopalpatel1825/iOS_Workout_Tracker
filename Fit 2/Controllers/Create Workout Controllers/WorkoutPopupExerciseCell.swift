//
//  WorkoutPopupExerciseCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/22/25.
//

import UIKit

class WorkoutPopupExerciseCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var letterLabel: UILabel!
    
    @IBOutlet weak var bodyPartLabel: UILabel!
    
    var exercise: WorkoutExercise?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        let bodyPart = exercise?.exercise?.bodyPart ?? ""
        bodyPartLabel.text = bodyPart
        let letter = exercise!.exercise!.name!.first!.description
        letterLabel.text = letter
        let count: Int = exercise?.sets?.count ?? 0
        nameLabel.text = "\(count) x \(exercise?.exercise?.name ?? "")"
    }
    
}
