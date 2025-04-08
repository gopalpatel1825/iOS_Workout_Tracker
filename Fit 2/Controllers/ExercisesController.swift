//
//  ExercisesController.swift
//  Fit 2
//
//  Created by Gopal Patel on 1/31/25.
//

import UIKit
import CoreData

class ExercisesController: UIViewController {
    
    
    var exercises: [Exercise] = []
    
    var fetchRequest: NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }
    
    var currentCategory: String? = nil { didSet { manageFetchRequest() } }
    
    var currentBodyPart: String? = nil { didSet { manageFetchRequest() } }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let coreDataHelper = CoreDataHelper.shared
    
    let k = Constants.shared
    
    
    @IBOutlet weak var workoutBar: UIView!
    
    @IBOutlet weak var workoutBarLabel: UILabel!
    
    @IBOutlet weak var workoutResumeButton: UIButton!
    
    @IBOutlet weak var workoutDiscardButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var bodyPartButton: UIButton!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var bodyPartMenu: UIMenu {
        return UIMenu(children: categoryItems)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ExerciseCell", bundle: nil), forCellReuseIdentifier: "ExerciseCell")
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors?.append(sortDescriptor)
        
        DispatchQueue.main.async {
            
            self.hideWorkoutBar()
            
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.fetchExercises), name: NSNotification.Name("ExerciseSaved"), object: nil)
        
        fetchExercises()
        
        categoryButton.menu = categoryMenu
        categoryButton.showsMenuAsPrimaryAction = true
        bodyPartButton.menu = bodyPartMenu
        bodyPartButton.showsMenuAsPrimaryAction = true
        
    }
    
    
    @IBAction func newPressed(_ sender: UIBarButtonItem) {
        
        let overLayer = AddExercisePopUpController()
        overLayer.appear(sender: self)
        
    }
    
    
    @IBAction func resumeWorkoutPressed(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "WorkoutController") as! WorkoutController
        
        vc.workout = k.currentWorkout
        
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        
    }
    
    
    @IBAction func discardWorkoutPressed(_ sender: UIButton) {
        let context = coreDataHelper.workoutContext
        context.delete(k.currentWorkout!)
        k.currentWorkout = nil
        hideWorkoutBar()
    }
    
    
    @IBAction func categoryPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func bodyPartPressed(_ sender: UIButton) {
    }
    
    @objc func fetchExercises() {
        
        do {
            self.exercises = try coreDataHelper.baseExerciseContext.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    func manageFetchRequest() {
        
        if (currentCategory == nil && currentBodyPart == nil) {
            fetchExercises()
        } else if (currentCategory != nil && currentBodyPart != nil) {
            let predicate1 = NSPredicate(format: "category == %@", currentCategory!)
            let predicate2 = NSPredicate(format: "bodyPart == %@", currentBodyPart!)
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
            fetchRequest.predicate = compoundPredicate
            fetchExercises()
        } else if (currentCategory != nil) {
            let predicate = NSPredicate(format: "category == %@", currentCategory!)
            fetchRequest.predicate = predicate
            fetchExercises()
        } else {
            let predicate = NSPredicate(format: "bodyPart == %@", currentBodyPart!)
            fetchRequest.predicate = predicate
            fetchExercises()
        }
        
        if currentCategory != nil {
            categoryButton.titleLabel?.text = currentCategory
        } else {
            categoryButton.titleLabel?.text = "All Categories"
        }
        
        if currentBodyPart != nil {
            bodyPartButton.titleLabel?.text = currentBodyPart
        } else {
            bodyPartButton.titleLabel?.text = "All Body Parts"
        }
    
    }
    
    
}

// MARK - Tableview Methods
extension ExercisesController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = mainStoryboard.instantiateViewController(withIdentifier: "ExercisesRootController") as! ExercisesRootController
        
        let exercise = exercises[indexPath.row]
        destination.exercise = exercise
        
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < 100 {
            navigationController?.title = ""
        } else {
            navigationController?.title = "Exercises"
        }
        
        
    }
    
}
                          


// Workout Bar Methods
extension ExercisesController {
    
    func hideWorkoutBar() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.workoutBar.isHidden = true
                self.workoutBar.frame.size.height = 0
                self.tableViewBottomConstraint.constant = -60
                self.view.layoutIfNeeded()
            })
            self.workoutResumeButton.isHidden = true
            self.workoutResumeButton.isEnabled = false
            self.workoutDiscardButton.isHidden = true
            self.workoutDiscardButton.isEnabled = false
        }
    }
    
    func showWorkoutBar() {
        DispatchQueue.main.async {
            self.workoutBar.isHidden = false
            self.workoutBar.frame.size.height = 100
            self.workoutBar.layer.cornerRadius = 10
            self.tableViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            
            self.workoutBar.layer.shadowColor = UIColor.black.cgColor
            self.workoutBar.layer.shadowRadius = 3
            self.workoutBar.layer.shadowOpacity = 0.5
            self.workoutBar.layer.shadowOffset = CGSize(width: 0, height: 2)
            
            self.workoutResumeButton.isHidden = false
            self.workoutResumeButton.isEnabled = true
            self.workoutDiscardButton.isHidden = false
            self.workoutDiscardButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            super.viewWillAppear(animated)
            if (self.k.currentWorkout != nil) {
                self.showWorkoutBar()
                self.workoutBarLabel.text = self.k.currentWorkout!.name
            } else {
                self.hideWorkoutBar()
                self.tableView.frame.size.height = self.tableView.frame.height + 60
            }
        }
        
    }
    
}
