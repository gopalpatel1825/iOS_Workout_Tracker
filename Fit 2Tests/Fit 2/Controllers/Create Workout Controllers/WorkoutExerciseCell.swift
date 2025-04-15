//
//  WorkoutExerciseCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/26/25.
//

import UIKit
import CoreData

class WorkoutExerciseCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addSet: UIButton!
    
    let coreDataHelper = CoreDataHelper.shared
    
    var exercise: WorkoutExercise? { didSet { configure()} }

    
    var sets: [Set] = []
    
    var lastSets: [Set] = []
    
    var previousSets = false
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "WorkoutSetCell", bundle: nil), forCellReuseIdentifier: "WorkoutSetCell")
        
    }
    
    

    @IBAction func addSetPressed(_ sender: UIButton) {
        
        let set = Set(context: coreDataHelper.workoutContext)
        exercise?.addToSets(set)
        //self.sets.append(set)
        self.sets = exercise!.sets!.array as! [Set]
        
        sets.sort { $0.index < $1.index }
        
        tableView.reloadData()
        
        DispatchQueue.main.async {
            (self.superview as? UICollectionView)?.collectionViewLayout.invalidateLayout()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "WorkoutSetCell", for: indexPath) as! WorkoutSetCell
        
        // Problem here
        let set = sets[indexPath.row]
        
        // If last sets are empty, set previous performance to zero so placeholders are zero
        if (lastSets.isEmpty) {
            print("No last sets for \(exercise!.exercise!.name)")
            set.previousWeight = 0
            set.previousReps = 0
        } else {
            // If the index path is inside the last sets, then give the placeholder the performance of the last reps
            if (indexPath.row + 1 <= lastSets.count) {
                set.previousWeight = lastSets[indexPath.row].weight
                set.previousReps = lastSets[indexPath.row].reps
            // If not, make the previous performance the same as last of the last sets
            } else {
                set.previousWeight = lastSets[lastSets.count - 1].weight
                set.previousReps = lastSets[lastSets.count - 1].reps
                print("\(lastSets.count) for \(exercise!.exercise!.name)")
            }
        }
        
        if (indexPath.row + 1 <= lastSets.count && previousSets) {
            let weight = lastSets[indexPath.row].weight
            let reps = lastSets[indexPath.row].reps
            
            cell.previousPerformanceLabel.text = "\(weight)lbs x \(reps)"
        }
        
        // Check if the set has been modified. If not, make the textfields blank
        if (set.modified == false) {
            cell.repsTextField.text = ""
            cell.weightTextField.text = ""
        }
        
        cell.set = set
        cell.setNumberLabel.text = "\(indexPath.row + 1)"
        cell.set!.index = Int64(indexPath.row)
        cell.configure()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let set = self.sets[indexPath.row]
            
            // Remove set from data source
            // Delete row from tableView
            self.sets.remove(at: indexPath.row)
            self.exercise?.removeFromSets(set)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Remove set from context
            self.coreDataHelper.workoutContext.delete(set)
            
            for (i, s) in self.sets.enumerated() {
                s.index = Int64(i)
            }
            
            tableView.reloadData()
            
            // Update collection view layout
            DispatchQueue.main.async {
                        (self.superview as? UICollectionView)?.collectionViewLayout.invalidateLayout()
                    }
            
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red // Optional: Custom color
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true // Enables full swipe delete
        
        tableView.reloadData()
        
        return configuration
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        tableView.layoutIfNeeded()
        tableView.frame.size.height = tableView.contentSize.height
            
        DispatchQueue.main.async {
            (self.superview as? UICollectionView)?.collectionViewLayout.invalidateLayout()
        }
    }
    
    func configure() {
        nameLabel.text = exercise!.exercise!.name
        fetchSets()
        fetchLastSets()
        
    }
    
    func fetchSets() {
        
        let context = coreDataHelper.workoutContext
        let setsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Set")
        setsFetchRequest.predicate = NSPredicate(format: "exercise == %@", self.exercise!)
        setsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        do {
            self.sets = try context.fetch(setsFetchRequest) as! [Set]
            //print("self.sets.count: \(self.sets.count) for \(self.exercise!.exercise!.name)")
            
            self.tableView.reloadData()
            
        } catch {
            fatalError("Failed to fetch sets: \(error)")
        }
    }
    
    
    func fetchLastSets() {
        
        let context = coreDataHelper.mainContext
        
        let baseExercise = self.exercise!.exercise!
        
        lastSets = baseExercise.getLastWorkoutSets(context: context)
        
        print("\(lastSets.count) sets from last workout for \(baseExercise.name)")
        
        if (!lastSets.isEmpty) {
            previousSets = true
        } else {
            lastSets = baseExercise.getLastTemplateSets(context: context)
            print("\(lastSets.count) sets from last template for \(baseExercise.name)")
        }
        
    }
    
    
    
}
