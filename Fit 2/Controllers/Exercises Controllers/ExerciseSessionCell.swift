//
//  ExerciseSessionCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/19/25.
//

import UIKit
import CoreData

class ExerciseSessionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var volumeLabel: UILabel!
    
    @IBOutlet weak var avgVolumeLabel: UILabel!
    
    @IBOutlet weak var numSetsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var exercise: WorkoutExercise?
    
    var sets: [Set] = []
    
    let coreDataHelper = CoreDataHelper.shared
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "WorkoutDetailsSetCell", bundle: nil), forCellReuseIdentifier: "WorkoutDetailsSetCell")
    }
    
    func configure() {
        
        nameLabel.text = exercise!.workout!.name!
        
        fetchSets()
        
    }
    
    func fetchSets() {
        
        let setsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Set")
        setsFetchRequest.predicate = NSPredicate(format: "exercise == %@", self.exercise!)
        setsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        do {
            self.sets = try coreDataHelper.mainContext.fetch(setsFetchRequest) as! [Set]
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            fatalError("Failed to fetch sets: \(error)")
        }
        
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

extension ExerciseSessionCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutDetailsSetCell", for: indexPath) as! WorkoutDetailsSetCell
        
        cell.set = sets[indexPath.row]
        cell.configure()
        
        return cell
        
    }
    
    
}
