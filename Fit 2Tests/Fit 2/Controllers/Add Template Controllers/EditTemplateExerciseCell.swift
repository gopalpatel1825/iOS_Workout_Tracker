//
//  EditTemplateExerciseCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/3/25.
//

import UIKit
import CoreData

class EditTemplateExerciseCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let coreDataHelper = CoreDataHelper.shared
    
    var exercise: WorkoutExercise?
    
    var sets: [Set] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TemplateSetCell", bundle: nil), forCellReuseIdentifier: "TemplateSetCell")
        
        tableView.reloadData()
    }

    @IBAction func addSetPressed(_ sender: UIButton) {
        let set = Set(context: coreDataHelper.templateContext)
        exercise?.addToSets(set)
        sets = exercise!.sets!.array as! [Set]
        set.index = Int64(sets.count)
        
        sets.sort { $0.index < $1.index }
        
        tableView.reloadData()
        
        DispatchQueue.main.async {
            (self.superview as? UICollectionView)?.collectionViewLayout.invalidateLayout()
        }
        
    }
    
    
    func configure() {
        nameLabel.text = exercise!.exercise!.name
        
        let setsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Set")
        setsFetchRequest.predicate = NSPredicate(format: "exercise == %@", self.exercise!)
        setsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        do {
            self.sets = try coreDataHelper.templateContext.fetch(setsFetchRequest) as! [Set]
            
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch sets: \(error)")
        }
    }
    
}

// MARK - Tableview

extension EditTemplateExerciseCell {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TemplateSetCell", for: indexPath) as! TemplateSetCell
        
        cell.set = sets[indexPath.row]
        cell.numberOfSetsLabel.text = "\(indexPath.row + 1)"
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
            self.coreDataHelper.templateContext.delete(set)
            
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

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if (editingStyle == .insert) {
            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
}
