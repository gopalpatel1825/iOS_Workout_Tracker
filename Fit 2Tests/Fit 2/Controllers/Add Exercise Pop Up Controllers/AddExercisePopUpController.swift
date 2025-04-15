//
//  AddExercisePopUp.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/2/25.
//

import UIKit

class AddExercisePopUpController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var bodyPartButton: UIButton!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var bodyPartLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    var sender: ExercisesController?
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let coreDataHelper = CoreDataHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hide))
        backView.addGestureRecognizer(tapGesture)
        
        manageSaveButton()
    }
    
    
    init() {
        super.init(nibName: "AddExercisePopUp", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    

    // Handles save button being pressed
    // Saves exercise to CoreData's main context and sends exersize saved notification
    @IBAction func savePressed(_ sender: UIButton) {
        // Make a new exercise in the base exericise context
        let context = coreDataHelper.baseExerciseContext
        
        let newExercise = Exercise(context: context)
        
        newExercise.name = textField.text ?? ""
        newExercise.category = categoryLabel.text ?? ""
        newExercise.bodyPart = bodyPartLabel.text ?? ""

        // Try to to save the exercise to CoreData main context
        do {
            try coreDataHelper.baseExerciseContext.save()
            try coreDataHelper.mainContext.save()
            // Send notification to the exercises controller that a new exercise was saved and it should reload tableview
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("ExerciseSaved"), object: nil)
            }
        } catch {
            print("Failed to exercise to main context \(error)")
        }
    
        self.hide()
    }
    
    
    @IBAction func bodyPartPressed(_ sender: UIButton) {
        
        let overlayer = BodyPartPopUpController()
        overlayer.appear(sender: self)
        
    }
    
    @IBAction func categoryPressed(_ sender: UIButton) {
        
        let overlayer = CategoryPopUpController()
        overlayer.appear(sender: self)
        
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.hide()
    }
    
    
    func manageSaveButton() {
        if textField.text == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        manageSaveButton()
    }
    
}

// MARK - Popup methods

extension AddExercisePopUpController {
    
    // Makes configures the view and makes the background dim
    func configView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        self.contentView.alpha = 1
        self.contentView.layer.cornerRadius = 10

    }
    
    func appear(sender: UIViewController) {
        sender.presentPopup(self)
        self.sender = sender as? ExercisesController
        DispatchQueue.main.async {
            self.configView()
        }
    }
    
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        } completion:  {_ in
            DispatchQueue.main.async {
                self.sender!.view.alpha = 1
                self.dismissPopup()
            }
            self.removeFromParent()
        
        }
    }
    
}
