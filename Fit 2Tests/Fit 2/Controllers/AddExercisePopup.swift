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
    
    
    var exercises: [Exercise] = []
    
    var selectedExercises: [Exercise] = []
    
    var selectedExercise: Exercise?
    
    let coreDataHelper = CoreDataHelper.shared
    
    var context: NSManagedObjectContext? = nil
    
    var sender: AddExercisePopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ExerciseCell", bundle: nil), forCellReuseIdentifier: "ExerciseCell")
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hide))
//        self.view.addGestureRecognizer(tapGesture)
        
        do {
            self.exercises = try context!.fetch(Exercise.fetchRequest())
            tableView.reloadData()
        } catch {
            
        }
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
