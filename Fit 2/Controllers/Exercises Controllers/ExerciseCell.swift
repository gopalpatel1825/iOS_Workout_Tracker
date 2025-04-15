//
//  ExerciseCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/2/25.
//

import UIKit

class ExerciseCell: UITableViewCell {
    
    var exercise: Exercise?

   
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bodyPartLabel: UILabel!
    let identifier = "ExerciseCell"
    
    @IBOutlet weak var mediaView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mediaView.layer.cornerRadius = 20
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        nameLabel.text = exercise?.name
        bodyPartLabel.text = exercise?.bodyPart
        mediaView.image = UIImage(named: "AppIcon")
    }

    
}
