//
//  TemplateCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/2/25.
//

import UIKit

class TemplateCell: UICollectionViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
 
    @IBOutlet weak var optionButton: UIButton!
    
    @IBOutlet weak var backview: UIView!
    
    private var dimmingView: UIView?
    
    var template: Template?
    var folder: Folder?
    var homeController: HomeController?
    var index: Int?
    
    let coreDataHelper = CoreDataHelper.shared
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Edit Template", image: UIImage(systemName: "pencil.fill"), handler: { (_) in
                let overlayer = CreateTemplateController()
                overlayer.template = self.template!
                overlayer.folder = self.folder!
                overlayer.appear(sender: self.homeController!)
            }),
            
            UIAction(title: "Delete..", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
                let context = self.coreDataHelper.mainContext
                context.delete(self.template!)
                // Delete the template  write the code under here
                self.coreDataHelper.saveMainContext()
                self.homeController!.reloadFolders()
            })
        ]
    }

    var demoMenu: UIMenu {
        return UIMenu(children: menuItems)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
        
    }
    
    func configure() {
        
        titleLabel.text = self.template?.name
        
        optionButton.layer.cornerRadius = 10
        optionButton.imageView?.image = UIImage(systemName: "ellipsis")
        
        backview.layer.cornerRadius = 10
        
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor //change to required color
        self.layer.borderWidth = 2 //change to required borderwidth
        
        configureButtonMenu()
        
    }
    
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        
    }
    
    func configureButtonMenu() {
        optionButton.menu = demoMenu
        
        optionButton.showsMenuAsPrimaryAction = true
    }
    

}
