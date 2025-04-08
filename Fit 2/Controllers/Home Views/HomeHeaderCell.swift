//
//  HomeHeaderCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/24/25.
//

import UIKit

class HomeHeaderCell: UICollectionViewCell {
    
    
    @IBOutlet weak var newTemplateButton: UIButton!
    
    @IBOutlet weak var startEmptyWorkoutButton: UIButton!
    
    @IBOutlet weak var newFolderButton: UIButton!
    
    var homeController: HomeController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newTemplateButton.layer.cornerRadius = 10
        startEmptyWorkoutButton.layer.cornerRadius = 10
        newFolderButton.layer.cornerRadius = 10
        
    }
    
    
    @IBAction func startWorkoutPressed(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func newTemplatePressed(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func newFolderPressed(_ sender: UIButton) {
        
        let overlayer = NewFolderPopup()
        overlayer.appear(sender: self.homeController!)
        
    }
    
}
