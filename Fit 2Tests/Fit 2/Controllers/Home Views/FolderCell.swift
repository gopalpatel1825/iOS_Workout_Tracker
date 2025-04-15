//
//  FolderCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/24/25.
//

import UIKit
import CoreData

class FolderCell: UICollectionViewCell {
    
    @IBOutlet weak var nameButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var optionsButton: UIButton!
    
    let coreDataHelper = CoreDataHelper.shared
    
    var homeController: HomeController?
    
    var folder: Folder?
    
    var fetchedTemplates: [Template] = []
    
    var templates: [Template] = []
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "New Template", image: UIImage(systemName: "plus"), handler: { (_) in
                let context = self.coreDataHelper.templateContext
                let template = Template(context: context)
                let overlayer = CreateTemplateController()
                
                let folderID = self.folder!.objectID
                let folderInContext = context.object(with: folderID) as! Folder
                
                overlayer.folder = folderInContext
                overlayer.template = template
                overlayer.sender = self.homeController
                self.homeController!.present(overlayer, animated: true)
            }),
            UIAction(title: "Delete..", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
                self.coreDataHelper.mainContext.delete(self.folder!)
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "TemplateCell", bundle: nil), forCellWithReuseIdentifier: "TemplateCell")
    }
    
    func fetchTemplates() {
        let fetchRequest = NSFetchRequest<Template>(entityName: "Template")
        fetchRequest.predicate = NSPredicate(format: "folder == %@", folder!)
        let context = coreDataHelper.mainContext
        do {
            fetchedTemplates = try context.fetch(fetchRequest)
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
        } catch {
            print("Could not fetch templates \(error)")
        }
        templates = fetchedTemplates
    }
    
    
    @IBAction func nameButtonPressed(_ sender: UIButton) {
        
        //        if (folder!.collapsed) {
        //            expandFolder()
        //            folder!.collapsed = false
        //        } else {
        //            collapseFolder()
        //            folder!.collapsed = true
        //        }
        
        guard let homeController = homeController,
              let indexPath = homeController.collectionView.indexPath(for: self),
              let folder = folder else { return }
        
        // Toggle collapse state
        folder.collapsed.toggle()
        
        if (folder.collapsed) {
            self.nameButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        } else {
            self.nameButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        
        // Animate height change
        UIView.animate(withDuration: 0.3) {
            homeController.collectionView.performBatchUpdates(nil, completion: nil)
        }
        
    }
    
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        
    }
    
    func configure() {
        
        fetchTemplates()
        
        nameButton.setTitle(folder!.name! + "(\(folder!.templates!.count)) ", for: .normal)//.titleLabel?.text = folder!.name! + " "
        
        if (folder!.collapsed) {
            self.nameButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        } else {
            self.nameButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }
        
        print("\(fetchedTemplates.count) templates for \(folder!.name!)")
        
        if folder?.collapsed == true {
            templates = []
        } else {
            templates = fetchedTemplates
        }
        
        configureButtonMenu()
        collectionView.reloadData()
        
    }
    
    func collapseFolder() {
        //templates = []
        let count = fetchedTemplates.count
        let height = self.frame.height
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            //self.collectionView.reloadData()
            self.frame.size.height = height - CGFloat(count * 110)
        }
    }
    
    func expandFolder() {
        //templates = fetchedTemplates
        let count = fetchedTemplates.count
        let height = self.frame.height
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            //self.collectionView.reloadData()
            self.frame.size.height = height + CGFloat(count * 110)
        }

    }
    
    
    func configureButtonMenu() {
        optionsButton.menu = demoMenu
        
        optionsButton.showsMenuAsPrimaryAction = true
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

extension FolderCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateCell", for: indexPath) as! TemplateCell
        
        cell.template = templates[indexPath.row]
        cell.folder = self.folder
        cell.homeController = self.homeController
        cell.configure()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let template = templates[indexPath.row]
        
        let overlayer = StartWorkoutPopup()
        overlayer.template = template
        overlayer.sender = self.homeController
        overlayer.configView()
        self.homeController!.presentPopup(overlayer)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space)
        
        return CGSize(width: size, height: 100)
    }
    
    
}
