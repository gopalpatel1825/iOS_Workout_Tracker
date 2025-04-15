//
//  HistoryController.swift
//  Fit 2
//
//  Created by Gopal Patel on 1/31/25.
//

import UIKit
import CoreData

class HistoryController: UIViewController {
    
    let coreDataHelper = CoreDataHelper.shared
    
    let k = Constants.shared
    
    var workouts: [Workout] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var workoutBar: UIView!
    
    @IBOutlet weak var workoutBarLabel: UILabel!
    
    @IBOutlet weak var workoutResumeButton: UIButton!
    
    @IBOutlet weak var workoutDiscardButton: UIButton!
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
        
        collectionView.register(UINib(nibName: "HistoryHeaderCell", bundle: nil), forCellWithReuseIdentifier: "HistoryHeaderCell")
        collectionView.register(UINib(nibName: "HistoryWorkoutCell", bundle: nil), forCellWithReuseIdentifier: "HistoryWorkoutCell")
        
        self.loadData()
        
        setApperance()
        
        hideWorkoutBar()
        
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
        do {
            try context.save()
        } catch {
            print("Could not save discard workout \(error)")
        }
        k.currentWorkout = nil
        hideWorkoutBar()
    }
    
    func loadData() {
        
        print("load data called")
        let workoutsFetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        workoutsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        
        do {
            workouts = try coreDataHelper.mainContext.fetch(workoutsFetchRequest)
        } catch {
            print("Failed to retrieve workout history")
        }
        collectionView.reloadData()
        
    }
    
}

extension HistoryController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workouts.count + 1
    }
    
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == 0 ) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryHeaderCell", for: indexPath) as! HistoryHeaderCell
            return cell
        } else {
    
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryWorkoutCell", for: indexPath) as! HistoryWorkoutCell
            let workout = workouts[indexPath.row - 1]
            cell.workout = workout
            cell.historyController = self
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = mainStoryboard.instantiateViewController(withIdentifier: "WorkoutDetailsController") as! WorkoutDetailsController
        
        let workout = workouts[indexPath.row - 1]
        destination.workout = workout
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowLayout?.minimumInteritemSpacing ?? 0.0) + (flowLayout?.sectionInset.left ?? 0.0) + (flowLayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space)
        
        if (indexPath.row == 0) {
            return (CGSize(width: size, height: 70))
        } else {
            let workout = workouts[indexPath.row - 1]
            let estimatedSetHeight: CGFloat = 60 // Adjust based on average set height
            let totalTableHeight = CGFloat(workout.exercises?.count ?? 0) * estimatedSetHeight
            
            return CGSize(width: size, height: totalTableHeight + 40)
        }
    }

}

extension HistoryController {
    
    func hideWorkoutBar() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.workoutBar.isHidden = true
                self.workoutBar.frame.size.height = 0
                self.collectionViewBottomConstraint.constant = -60
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
            self.collectionViewBottomConstraint.constant = 0
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
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.loadData()
            if (self.k.currentWorkout != nil) {
                self.showWorkoutBar()
                self.workoutBarLabel.text = self.k.currentWorkout!.name
            } else {
                self.hideWorkoutBar()
                self.collectionView.frame.size.height = self.collectionView.frame.height + 60
            }
        }
    }
    
    private func setApperance() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tabBar
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

