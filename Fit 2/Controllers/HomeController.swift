//
//  ViewController.swift
//  Fit 2
//
//  Created by Gopal Patel on 1/30/25.
//

import UIKit
import CoreData

class HomeController: UIViewController {
    
    @IBOutlet weak var workoutBar: UIView!
    
    @IBOutlet weak var workoutBarLabel: UILabel!
    
    @IBOutlet weak var workoutResumeButton: UIButton!
    
    @IBOutlet weak var workoutDiscardButton: UIButton!

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    
    let coreDataHelper = CoreDataHelper.shared

    let k = Constants.shared
    
    var folders: [Folder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "HomeHeaderCell", bundle: nil), forCellWithReuseIdentifier: "HomeHeaderCell")
        
        collectionView.register(UINib(nibName: "FolderCell", bundle: nil), forCellWithReuseIdentifier: "FolderCell")
        
        reloadFolders()
        
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
        k.currentWorkout = nil
        hideWorkoutBar()
    }
    
    
    func presentWorkoutEditor(template: Template) {
        print(" Presenting workout editor")
        // Make a new view controller in the storyboard
        let vc = storyboard?.instantiateViewController(withIdentifier: "WorkoutController") as! WorkoutController
        // Find the template in the workout context
        let templateWorkoutContext = coreDataHelper.workoutContext.object(with: template.objectID) as? Template
        // Make a new workout in the workout context and initialize it with the templates data
        let workout = Workout(context: coreDataHelper.workoutContext)
        templateWorkoutContext?.initializeWorkout(workout: workout)
        // Assign the workout and template to the workout
        workout.startDate = Date()
        vc.workout = workout
        
        let name = templateWorkoutContext!.name
        workout.name = name
        
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
        self.k.currentWorkout = workout
        
        showWorkoutBar()

    }
    
    func reloadFolders() {
        print("reload folders called")
        let fetchRequest = NSFetchRequest<Folder>(entityName: "Folder")
        let context = coreDataHelper.mainContext
        do {
            folders = try context.fetch(fetchRequest)
            for folder in folders {
                print("Folder name: \(folder.name!), template count \(folder.templates!.count)")
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            print("Could not fetch folders \(error)")
        }
        
        DispatchQueue.main.async {
//            self.collectionView.performBatchUpdates({
//                self.collectionView.reloadSections(IndexSet(integer: 0))
//            }, completion: nil)
            self.collectionView.reloadData()
        }

        
    }
    
    
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return folders.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (indexPath.row == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderCell", for: indexPath) as! HomeHeaderCell
            cell.homeController = self
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
            
            let folder = folders[indexPath.row - 1]
            cell.folder = folder
            cell.homeController = self
            cell.configure()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width)
        
        if (indexPath.row == 0) {
            return CGSize(width: size, height: 180)
        } else {
            let folder = folders[indexPath.row - 1]
            let isCollapsed = folder.collapsed
            let baseHeight: CGFloat = 40

            if isCollapsed {
                return CGSize(width: size, height: baseHeight)
            } else {
                let count = folder.templates?.count ?? 0
                let cellHeight = CGFloat(count * 110)
                return CGSize(width: size, height: baseHeight + cellHeight)
            }

        }
    }
    
    
}

// MARK - Workout Bar methods
extension HomeController {
    
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
        print("view will appear called")
        DispatchQueue.main.async {
            super.viewWillAppear(animated)
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
        appearance.backgroundColor = UIColor(named: "TabBarColor")
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}
    
    

