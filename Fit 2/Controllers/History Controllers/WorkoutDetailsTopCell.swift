//
//  WorkoutDetailsTopCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/14/25.
//

import UIKit

class WorkoutDetailsTopCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var volumeLabel: UILabel!
    
    @IBOutlet weak var numSetsLabel: UILabel!
    
    var workout: Workout?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configure() {
        let name = workout!.name
        nameLabel.text = name
        
        let date = workout!.startDate!
        let dateString = date.formatted(date: .complete, time: .shortened)
        
        dateLabel.text = dateString
        
        let duration = "\(workout!.duration)"
        durationLabel.text = duration
        
        let volume = "\(workout!.totalVolume)"
        volumeLabel.text = volume
        
        let numSets = "\(workout!.numSets)"
        numSetsLabel.text = numSets
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }

}
