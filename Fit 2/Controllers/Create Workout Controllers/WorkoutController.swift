//
//  WorkoutController.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/25/25.
//

import Foundation
import UIKit


class WorkoutController: UIViewController {
    
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var timerButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var stopWatchLabel: UILabel!
    
    let coreDataHelper = CoreDataHelper.shared
    
    let k = Constants.shared
    
    let restManager = RestTimerManager.shared
    
    var workout: Workout?
    
    var exercises: [WorkoutExercise] = []
    
    
    var tabBarHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timerButton.layer.cornerRadius = 5
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "WorkoutExerciseCell", bundle: nil), forCellWithReuseIdentifier: "WorkoutExerciseCell")
        collectionView.register(UINib(nibName: "WorkoutEditorHeaderCell", bundle: nil), forCellWithReuseIdentifier: "WorkoutEditorHeaderCell")
        collectionView.register(UINib(nibName: "WorkoutEditorBottomCell", bundle: nil), forCellWithReuseIdentifier: "WorkoutEditorBottomCell")
        
        startStopWatch()
        
        DispatchQueue.main.async {
            self.loadExercises()
            self.collectionView.reloadData()
        }
        
        self.workout!.name = self.workout!.template!.name
        
    }
    
    
    @IBAction func timerPressed(_ sender: UIButton) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = mainStoryboard.instantiateViewController(withIdentifier: "RestTimerController") as! RestTimerController
        
        destination.modalPresentationStyle = .pageSheet
        
        self.present(destination, animated: true, completion: nil)
       
    }
    
    
    @IBAction func finishPressed(_ sender: UIButton) {
        
        let context = coreDataHelper.workoutContext
        var volume: Float = 0.0
        var numSets: Int = 0
        
        // Delete the sets that are not marked as complete or whose volume is zero
        for exercise in self.workout!.exercises!.array as! [WorkoutExercise] {
            for aset in exercise.sets!.array as! [Set] {
                aset.calculateStatistics()
                if (aset.completed != true || aset.volume == 0) {
                    exercise.removeFromSets(aset)
                    context.delete(aset)
                }
            }
            // If an exercise has no sets, delete it
            if (exercise.sets!.count == 0) {
                self.workout?.removeFromExercises(exercise)
                exercise.workout = nil
            }
        }
        
        for exercise in self.workout!.exercises!.array as! [WorkoutExercise] {
            print("Exercise Name: \(exercise.exercise!.name!), Exercise sets: \(exercise.sets!.count)")
            // Add base exercise to workouts
            let baseExercise = exercise.exercise!
            baseExercise.addToWorkouts(self.workout!)
            
            for aset in exercise.sets!.array as! [Set] {
                print("Set \(aset.index + 1): Weight: \(aset.weight), Reps: \(aset.reps)")
                baseExercise.refreshPersonalRecords()
                volume = volume + Float(aset.volume)
                numSets += 1
            }
        }
        
        self.workout?.totalVolume = Int64(volume)
        self.workout?.numSets = Int64(numSets)
        print("Total volume for workout: \(volume)")
        stopStopwatch()
        restManager.reset()
        calculateDateAndDuration()
        
        coreDataHelper.saveGivenContext(context: context)
        coreDataHelper.saveMainContext()
        context.rollback()
        
        k.currentWorkout = nil
        
        self.dismiss(animated: true)
    }
    
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.removeFromParent()
    }
    
    func loadExercises() {
        self.exercises = self.workout?.exercises?.array as? [WorkoutExercise] ?? []
        collectionView.reloadData()
    }
    
}




// MARK - Collection View Methods
extension WorkoutController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row == 0) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutEditorHeaderCell", for: indexPath) as! WorkoutEditorHeaderCell
            cell.titleLabel.text = "\(workout!.name ?? "No name")"
            
            return cell
            
        } else if (indexPath.row == exercises.count + 1) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutEditorBottomCell", for: indexPath) as! WorkoutEditorBottomCell
            
            cell.workout = self.workout
            cell.workoutController = self
            
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutExerciseCell", for: indexPath) as! WorkoutExerciseCell
            cell.exercise = self.exercises[indexPath.row - 1]
            cell.workout = self.workout!
            cell.workoutController = self
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space)
        
        if (indexPath.row == 0) {
            return CGSize(width: size, height: 40)
        } else if (indexPath.row == exercises.count + 1) {
            return CGSize(width: size, height: 400)
        } else {
            let exercise = exercises[indexPath.row - 1]
            let estimatedSetHeight: CGFloat = 44 // Adjust based on average set height
            let totalTableHeight = CGFloat(exercise.sets?.count ?? 0) * estimatedSetHeight
            
            return CGSize(width: size, height: totalTableHeight + 100)
        }
    }
}


// StopWatch methods
extension WorkoutController {
    
    func startStopWatch() {
            let manager = WorkoutTimerManager.shared
            
            stopWatchLabel.text = manager.formattedTime()
            
            manager.onTick = { [weak self] _ in
                self?.stopWatchLabel.text = manager.formattedTime()
            }
            
            manager.start()
        }

        func stopStopwatch() {
            WorkoutTimerManager.shared.stop()
        }

        func calculateDateAndDuration() {
            let manager = WorkoutTimerManager.shared
            let duration = manager.elapsedTime / 60 // minutes
            let date = Date()
            
            self.workout?.duration = Int64(duration)
            self.workout?.endDate = date
            
            print("Workout duration: \(duration) minutes, date: \(date)")
        }
}

extension WorkoutController: AddExercisePopupDelegate {
    
    func addToTemplateOrWorkout(exercise: WorkoutExercise) {
        self.workout!.addToExercises(exercise)
        exercise.workout = self.workout!
        exercise.date = exercise.workout?.startDate
        self.exercises = self.workout!.exercises!.array as! [WorkoutExercise]//self.exercises.append(exercise)
        self.collectionView.reloadData()
    }


}
