//
//  WorkoutEditorBottomCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/15/25.
//

import UIKit

class WorkoutEditorBottomCell: UICollectionViewCell {
    
    var workout: Workout?
    
    var workoutController: WorkoutController?
    
    let coreDataHelper = CoreDataHelper.shared

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addExercisePressed(_ sender: UIButton) {
        let overlayer = AddExercisePopup()
        let context = coreDataHelper.workoutContext
        overlayer.context = context
        overlayer.appear(sender: self.workoutController!)
    }
    
    
    @IBAction func calculatorsPressed(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func discardWorkoutPressed(_ sender: UIButton) {
        
        
    }
    
    
}
