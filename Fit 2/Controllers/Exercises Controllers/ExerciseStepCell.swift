//
//  ExerciseStepCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 4/6/25.
//

import UIKit

class ExerciseStepCell: UITableViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var stepLabel: UILabel!
    
    var step: Step?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
