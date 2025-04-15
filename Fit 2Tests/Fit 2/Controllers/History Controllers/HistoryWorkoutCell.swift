//
//  HistoryExerciseCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/4/25.
//

import UIKit
import CoreData

class HistoryWorkoutCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var volumeLabel: UILabel!
    
    @IBOutlet weak var numSetsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var optionsButton: UIButton!
    
    let coreDataHelper = CoreDataHelper.shared
    
    var workout: Workout? { didSet {configure() } }
    
    var exercises: [WorkoutExercise] = []
    
    var historyController: HistoryController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        
        
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor //change to required color
        self.layer.borderWidth = 1 //change to required borderwidth
        
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Edit Workout", image: UIImage(systemName: "pencil.fill"), handler: { (_) in
                // TODO - Make workout editor
            }),
            
            UIAction(title: "Delete...", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { (_) in
                let context = self.coreDataHelper.mainContext
                context.performAndWait {
                    context.delete(self.workout!)
                }
                self.coreDataHelper.saveMainContext()
//                do {
//                    try context.save()
//                } catch {
//                    print("Could not delete workout from history \(error)")
//                }
            
                self.historyController!.loadData()
            })
        ]
    }

    var demoMenu: UIMenu {
        return UIMenu(children: menuItems)
    }
    
    @IBAction func optionsPressed(_ sender: UIButton) {
        
        
        
    }
    
    func configure() {
        
        let name = workout!.name
        nameLabel.text = name
        
        let date = workout!.startDate!
        let dateString = date.formatted(date: .complete, time: .shortened)
        
        dateLabel.text = dateString
        
        let volume = "\(workout!.totalVolume)"
        volumeLabel.text = volume
        
        let duration = "\(workout!.duration)"
        durationLabel.text = duration
        
        let numSets = "\(workout!.numSets)"
        numSetsLabel.text = numSets
        
        let exerciseFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutExercise")
        exerciseFetchRequest.predicate = NSPredicate(format: "workout == %@", self.workout!)
        exerciseFetchRequest.sortDescriptors = [NSSortDescriptor(key: "exercise.name", ascending: true)]
        
        do {
            self.exercises = try coreDataHelper.mainContext.fetch(exerciseFetchRequest) as! [WorkoutExercise]
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.layoutSubviews()
            }
        } catch {
            fatalError("Failed to fetch workout exercises: \(error)")
        }
        
        configureButtonMenu()
        
    }
    
    func configureButtonMenu() {
        optionsButton.menu = demoMenu
        
        optionsButton.showsMenuAsPrimaryAction = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tableView.layoutIfNeeded()
        tableView.frame.size.height = tableView.contentSize.height
        
        DispatchQueue.main.async {
            (self.superview as? UICollectionView)?.collectionViewLayout.invalidateLayout()
        }
    }
}

extension HistoryWorkoutCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let exercise = exercises[indexPath.row]
        cell.exercise = exercise
        cell.configure()
        return cell
        
    }
    
}
    


