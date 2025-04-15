//
//  AddExercisePopup.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/5/25.
//

import UIKit
import CoreData

class AddExercisePopup: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var bodyPartButton: UIButton!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    
    var exercises: [Exercise] = []
    
    var context: NSManagedObjectContext?
    
    var currentCategory: String? = nil { didSet { print("Did set current category"); manageFetchRequest() } }
    
    var currentBodyPart: String? = nil { didSet { print("Did set current body part"); manageFetchRequest() } }
    
    var bodyPartMenu: UIMenu {
        return UIMenu(children: bodyPartItems)
    }
    
    var bodyPartItems: [UIAction] {
        return [
            UIAction(title: "All Body Parts", handler: { (_) in
                self.currentBodyPart = "All Body Parts"
            }),
            
            UIAction(title: "Core", handler: { (_) in
                self.currentBodyPart = "Core"
            }),
            
            UIAction(title: "Arms", handler: { (_) in
                self.currentBodyPart = "Arms"
            }),
            
            UIAction(title: "Back", handler: { (_) in
                self.currentBodyPart = "Back"
            }),
            
            UIAction(title: "Chest", handler: { (_) in
                self.currentBodyPart = "Chest"
            }),
            
            UIAction(title: "Legs", handler: { (_) in
                self.currentBodyPart = "Legs"
            }),
            
            UIAction(title: "Shoulders", handler: { (_) in
                self.currentBodyPart = "Shoulders"
            }),
            
            UIAction(title: "Cardio", handler: { (_) in
                self.currentBodyPart = "Cardio"
            }),
            
            UIAction(title: "Other", handler: { (_) in
                self.currentBodyPart = "Other"
            })
        ]
    }
    
    var categoryMenu: UIMenu {
        return UIMenu(children: categoryItems)
    }
    
    var categoryItems: [UIAction] {
        return [
            UIAction(title: "All Categories", handler: { (_) in
                self.currentCategory = "All Categories"
            }),
            
            UIAction(title: "Barbell", handler: { (_) in
                self.currentCategory = "Barbell"
            }),
            
            UIAction(title: "Dumbbell", handler: { (_) in
                self.currentCategory = "Dumbbell"
            }),
            
            UIAction(title: "Machine", handler: { (_) in
                self.currentCategory = "Machine"
            }),
            
            UIAction(title: "Weighted Bodyweight", handler: { (_) in
                self.currentCategory = "Weighted Bodyweight"
            }),
            
            UIAction(title: "Assisted Bodyweight", handler: { (_) in
                self.currentCategory = "Assisted Bodyweight"
            }),
            
            UIAction(title: "Reps Only", handler: { (_) in
                self.currentCategory = "Reps Only"
            }),
            
            UIAction(title: "Cardio", handler: { (_) in
                self.currentCategory = "Cardio"
            }),
            
            UIAction(title: "Other", handler: { (_) in
                self.currentCategory = "Other"
            })
        ]
    }
    
    let coreDataHelper = CoreDataHelper.shared
    
    var sender: AddExercisePopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ExerciseCell", bundle: nil), forCellReuseIdentifier: "ExerciseCell")
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hide))
//        self.view.addGestureRecognizer(tapGesture)
        
        manageFetchRequest()
        
        categoryButton.menu = categoryMenu
        categoryButton.showsMenuAsPrimaryAction = true
        bodyPartButton.menu = bodyPartMenu
        bodyPartButton.showsMenuAsPrimaryAction = true
        
        categoryButton.layer.cornerRadius = 10
        bodyPartButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func newPressed(_ sender: UIButton) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.hide()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func bodyPartButtonPressed(_ sender: UIButton) {
    }
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
    }
    
    func manageFetchRequest() {
        let request = NSFetchRequest<Exercise>(entityName: "Exercise") // new clean request
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        var predicates: [NSPredicate] = []
        
        // Filter only if category is not nil or not "All"
        if let category = currentCategory, category != "All Categories" {
            predicates.append(NSPredicate(format: "category == %@", category))
        }
        
        if let bodyPart = currentBodyPart, bodyPart != "All Body Parts" {
            predicates.append(NSPredicate(format: "bodyPart == %@", bodyPart))
        }
        
        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        do {
            self.exercises = try context!.fetch(request)
            self.tableView.reloadData()
        } catch {
            print("Failed to fetch filtered exercises: \(error)")
        }
        
        // Update button titles
        categoryButton.setTitle(currentCategory ?? "All Categories", for: .normal)
        bodyPartButton.setTitle(currentBodyPart ?? "All Body Parts", for: .normal)
    }
    
    
    init() {
        super.init(nibName: "TemplateAddExercisePopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
}

// Tableview Methods

extension AddExercisePopup {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
        
        cell.exercise = exercises[indexPath.row]
        cell.configure()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row selected")
        
        let newExercise = WorkoutExercise(context: context!)
        newExercise.exercise = exercises[indexPath.row]
        
        sender!.addToTemplateOrWorkout(exercise: newExercise)
        //sender!.reloadData()
        
        self.dismissPopup()
    }
}


extension AddExercisePopup {
    
    
    @objc func hide() {
        self.dismissPopup()
        self.removeFromParent()
    }
    
    
    func appear(sender: UIViewController) {
        sender.presentPopup(self)
        self.sender = sender as? AddExercisePopupDelegate
        self.backView.backgroundColor = .black.withAlphaComponent(0.6)
        DispatchQueue.main.async {
            self.configView()
        }
    }
    
    func configView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.5)
        self.contentView.alpha = 1
        self.contentView.layer.cornerRadius = 10

    }
    
}

protocol AddExercisePopupDelegate {
    
    func addToTemplateOrWorkout(exercise : WorkoutExercise)
    
}
