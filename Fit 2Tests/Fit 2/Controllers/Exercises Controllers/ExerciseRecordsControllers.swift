//
//  ExerciseRecordsControllers.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/27/25.
//

import UIKit

class ExerciseRecordsControllers: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ExercisesRecordsHeaderCell", bundle: nil), forCellWithReuseIdentifier: "ExercisesRecordsHeaderCell")
        
        collectionView.register(UINib(nibName: "ExercisesRecordsBodyCell", bundle: nil), forCellWithReuseIdentifier: "ExercisesRecordsBodyCell")
        
        collectionView.reloadData()
    }
    
}

extension ExerciseRecordsControllers: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExercisesRecordsHeaderCell", for: indexPath) as! ExercisesRecordsHeaderCell
            
            cell.exercise = self.exercise
            cell.configure()
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExercisesRecordsBodyCell", for: indexPath) as! ExercisesRecordsBodyCell
            cell.exercise = self.exercise
            
            if (indexPath.row == 1) {
                cell.configureFor1RM()
            } else if (indexPath.row == 2) {
                cell.configureForVolume()
            } else if (indexPath.row == 3) {
                cell.configureForWeight()
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowLayout?.minimumInteritemSpacing ?? 0.0) + (flowLayout?.sectionInset.left ?? 0.0) + (flowLayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space)
        let setHeight = 55 // Estimated height for set cell
        
        if (indexPath.row == 0) {
            return CGSize(width: size, height: 200)
        } else if (indexPath.row == 1) {
            let numSets = exercise?.oneRepMaxPRs!.count ?? 0
            let tableViewHeight = numSets * setHeight
            return CGSize(width: size, height: CGFloat(tableViewHeight + 25)) // Adjust padding as needed
        } else if (indexPath.row == 2) {
            let numSets = exercise?.maxVolumePRs!.count ?? 0
            let tableViewHeight = numSets * setHeight
            return CGSize(width: size, height: CGFloat(tableViewHeight + 25)) // Adjust padding as needed
        } else {
            let numSets = exercise?.maxWeightPRs!.count ?? 0
            let tableViewHeight = numSets * setHeight
            return CGSize(width: size, height: CGFloat(tableViewHeight + 25)) // Adjust padding as needed
        }
    
        
    }
    
    
}
