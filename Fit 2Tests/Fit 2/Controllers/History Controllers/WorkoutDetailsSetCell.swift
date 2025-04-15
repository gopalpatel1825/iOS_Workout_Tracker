//
//  WorkoutDetailsSetCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/14/25.
//

import UIKit

class WorkoutDetailsSetCell: UITableViewCell {
    
    
    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var oneRepMaxLabel: UILabel!
    
    
    var set: Set?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func configure() {
        
        setLabel.text = "\(self.set!.index + 1)"
        
        let reps = set!.reps
        let weight = set!.weight
        let oneRepMax = Int(set!.oneRepMax)
        
        infoLabel.text = "\(weight) lbs x \(reps) reps"
        
        oneRepMaxLabel.text = "\(oneRepMax)"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
