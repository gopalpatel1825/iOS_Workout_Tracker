//
//  CreateTemplateController.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/3/25.
//

import UIKit
import CoreData

class CreateTemplateController: UIViewController {
    
    var sender: HomeController?
    
    // The template that is being edited
    var template: Template?
    
    var folder: Folder?
    
    // The exercises that are being displayed
    // These will be set in viewDidLoad()
    var exercises: [WorkoutExercise] = []
    
    let coreDataHelper = CoreDataHelper.shared
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    init() {
        super.init(nibName: "CreateTemplateController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        textField.delegate = self
        
        collectionView.register(UINib(nibName: "EditTemplateExerciseCell", bundle: nil), forCellWithReuseIdentifier: "EditTemplateExerciseCell")
        
        // Make the notification center to listen for new base exercises being saved
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.loadExercises), name: NSNotification.Name("ExerciseSaved"), object: nil)
        
        loadExercises()
        
        manageSaveButton()
        
        print("Self.folder.name \(self.folder!.name)")
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        collectionView.reloadData()
        template?.name = textField.text
        print("\(template?.name ?? "nil")")
        
        folder!.addToTemplates(self.template!)
        self.template!.folder = self.folder!
        
        let context = coreDataHelper.templateContext
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("Error saving template to main context \(error)")
            }
        }
        
        coreDataHelper.mainContext.performAndWait {
            coreDataHelper.saveMainContext()
        }
        
        self.hide2() {
            self.sender!.reloadFolders()
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        let templateContext = coreDataHelper.templateContext
        
        if (isTemplateInMainContext()) {
            templateContext.rollback()
        } else {
            templateContext.delete(self.template!)
        }
        
        self.hide()
    }
    
    func isTemplateInMainContext() -> Bool {
        let context = coreDataHelper.mainContext
        
        do {
            let _ = try context.existingObject(with: self.template!.objectID)
            return true
        } catch {
            print("Error finding template in main context \(error)")
            return false
        }
    }
    
    @IBAction func addExercisePressed(_ sender: UIButton) {
        let overlayer = AddExercisePopup()
        let context = coreDataHelper.templateContext
        overlayer.context = context
        overlayer.appear(sender: self)
    }
    
}

extension CreateTemplateController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        manageSaveButton()
    }
    
    func manageSaveButton() {
        if textField.text == "" {
            textField.placeholder = "Enter a Template Name"
            saveButton.isEnabled = false
        } else {
            self.template?.name = textField.text
            saveButton.isEnabled = true
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        manageSaveButton()
    }
    
}

// MARK - Popup

extension CreateTemplateController {
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: true)
        self.sender = sender as? HomeController
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
        
        } completion:  {_ in
            self.dismiss(animated: true)
            self.removeFromParent()
        }
    }
    
    @objc func hide2(completion: @escaping () -> Void) {
        self.sender!.view.alpha = 1
        self.dismissPopup() {
            self.removeFromParent()
            completion()
        }
    }
}

// MARK - CollectionView Methods

extension CreateTemplateController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (exercises.count)
    }
    
    // Each cell gets its a single exercise
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditTemplateExerciseCell", for: indexPath) as! EditTemplateExerciseCell
        cell.exercise = self.exercises[indexPath.row]
        cell.configure()
        return cell
    }
}

extension CreateTemplateController: UICollectionViewDelegateFlowLayout {
    
    // Method for dynamically changing collectionView cell height as tableView height changes
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space)
        
        let cellWidth = collectionView.frame.width - space
        
        // Get the actual cell
        if let cell = collectionView.cellForItem(at: indexPath) as? EditTemplateExerciseCell {
            cell.layoutIfNeeded()
            let tableViewHeight = cell.tableView.contentSize.height
            return CGSize(width: cellWidth, height: tableViewHeight + 105) // Adjust padding as needed
        }
        
        return CGSize(width: size, height: size)
    }

}


extension CreateTemplateController {
    
     // Sets the array of exercises as the current templates exercises
     // Configures the label and the collectionView
    @objc func loadExercises() {
        self.exercises = self.template?.exercises?.array as! [WorkoutExercise]
        self.textField.text = self.template?.name
        collectionView.reloadData()
    }
    
    
}

extension CreateTemplateController: AddExercisePopupDelegate {
    
    // Protocol method for AddExerisePopupDelegate
    func reloadData() {
        collectionView.reloadData()
    }
    
    func addToTemplateOrWorkout(exercise: WorkoutExercise) {
        exercise.date = Date()
        self.template!.addToExercises(exercise)
        self.exercises = self.template!.exercises!.array as! [WorkoutExercise] // .append(exercise)
        self.collectionView.reloadData()
    }
    
}




