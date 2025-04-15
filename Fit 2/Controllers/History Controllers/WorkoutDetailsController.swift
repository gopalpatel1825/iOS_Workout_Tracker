//
//  WorkoutDetailsViewController.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/14/25.
//

import UIKit
import CoreData

class WorkoutDetailsController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var workout: Workout?
    
    var exercises: [WorkoutExercise] = []
    
    let coreDataHelper = CoreDataHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "WorkoutDetailsTopCell", bundle: nil), forCellWithReuseIdentifier: "WorkoutDetailsTopCell")
        collectionView.register(UINib(nibName: "WorkoutDetailsExerciseCell", bundle: nil), forCellWithReuseIdentifier: "WorkoutDetailsExerciseCell")
        
        loadData()
    }
    
    func loadData() {
        
        let exerciseFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutExercise")
        exerciseFetchRequest.predicate = NSPredicate(format: "workout == %@", self.workout!)
        exerciseFetchRequest.sortDescriptors = [NSSortDescriptor(key: "exercise.name", ascending: true)]
        
        do {
            self.exercises = try coreDataHelper.mainContext.fetch(exerciseFetchRequest) as! [WorkoutExercise]
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            fatalError("Failed to fetch workout exercises: \(error)")
        }
        
    }

    
}

extension WorkoutDetailsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutDetailsTopCell", for: indexPath) as! WorkoutDetailsTopCell
            cell.workout = self.workout!
            cell.configure()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutDetailsExerciseCell", for: indexPath) as! WorkoutDetailsExerciseCell
            cell.exercise = self.exercises[indexPath.row - 1]
            cell.configure()
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowLayout?.minimumInteritemSpacing ?? 0.0) + (flowLayout?.sectionInset.left ?? 0.0) + (flowLayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space)
        
        if (indexPath.row == 0) {
            
            return CGSize(width: size, height: 133)
            
        } else {
            
            let setHeight = 55 // Estimated height for set cell
            let numSets = exercises[indexPath.row - 1].sets!.count
            let tableViewHeight = numSets * setHeight
            
            return CGSize(width: size, height: CGFloat(tableViewHeight + 60)) // Adjust padding as needed
        }
    }

    
    
}
