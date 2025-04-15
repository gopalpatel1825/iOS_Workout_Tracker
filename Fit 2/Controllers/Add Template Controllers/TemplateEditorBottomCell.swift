//
//  TemplateEditorBottomCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 4/8/25.
//

import UIKit

class TemplateEditorBottomCell: UICollectionViewCell {
    
    var template: Template?
    
    var templateEditor: CreateTemplateController?
    
    let coreDataHelper = CoreDataHelper.shared
    
    
    @IBOutlet weak var addExerciseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func addExercisePressed(_ sender: UIButton) {
        let overlayer = AddExercisePopup()
        let context = coreDataHelper.templateContext
        overlayer.context = context
        overlayer.appear(sender: self.templateEditor!)
    }
    
}
