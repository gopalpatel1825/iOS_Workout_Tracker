//
//  ExercisesHistoryController.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/17/25.
//

import UIKit
import CoreData

class ExercisesHistoryController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var exercise: Exercise?
    
    var exercises: [WorkoutExercise] = []
    
    let coreDataHelper = CoreDataHelper.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ExerciseSessionCell", bundle: nil), forCellWithReuseIdentifier: "ExerciseSessionCell")
        
        configure()
        
    }
    
    func configure() {
        fetchSessions()
        
//        DispatchQueue.main.async {
//            self.collectionView.reloadData()
//        }
    }
    
    func fetchSessions() {
        
        let context = CoreDataHelper.shared.mainContext
            let fetchRequest: NSFetchRequest<WorkoutExercise> = WorkoutExercise.fetchRequest()
            
            // Predicate to match the specific exercise AND exclude those linked to a template
        fetchRequest.predicate = NSPredicate(format: "exercise == %@ AND template == nil", exercise!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

            do {
                let results = try context.fetch(fetchRequest)
                exercises = results
                print("Results.count \(results.count)")
                collectionView.reloadData()
            } catch {
                print("Error fetching WorkoutExercises for Exercise \(exercise!.name ?? "Unknown"): \(error)")
                exercises = []
            }
        
    }

}

extension ExercisesHistoryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseSessionCell", for: indexPath) as! ExerciseSessionCell
        
        cell.exercise = exercises[indexPath.row]
        cell.configure()
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowLayout?.minimumInteritemSpacing ?? 0.0) + (flowLayout?.sectionInset.left ?? 0.0) + (flowLayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space)
        
        let setHeight = 55 // Estimated height for set cell
        let numSets = exercises[indexPath.row].sets!.count
        let tableViewHeight = numSets * setHeight
        
        return CGSize(width: size, height: CGFloat(tableViewHeight + 110)) // Adjust padding as needed
        
    }

    
    
}
