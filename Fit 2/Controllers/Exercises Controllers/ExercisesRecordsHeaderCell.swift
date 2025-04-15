//
//  ExercisesRecordsHeaderCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/27/25.
//

import UIKit
import CoreData

class ExercisesRecordsHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var oneRepMaxLabel: UILabel!
    
    
    @IBOutlet weak var volumeLabel: UILabel!
    
    
    @IBOutlet weak var weightLabel: UILabel!
    
    let coreDataHelper = CoreDataHelper.shared
    
    var exercise: Exercise?
    
    var best1RMSet: Set?
    
    var bestVolumeSet: Set?
    
    var bestWeightSet: Set?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure() {
        
        
        fetchPRs()
        configureLabels()
        
    }
    
    func configureLabels() {
        
        titleLabel.text = "Personal Records - \(exercise!.name!)"
        
        let oneRepMaxString = String(format: "%.0flbs", best1RMSet?.oneRepMax ?? 0)// "\(best1RMSet?.oneRepMax ?? 0)lbs"
        oneRepMaxLabel.text = oneRepMaxString
        
        let volumeString = String(format: "%.0flbs", bestVolumeSet?.volume ?? 0)//"\(bestVolumeSet?.volume ?? 0)"
        volumeLabel.text = volumeString
        
        let weightString = String(format: "%0.1flbs", bestWeightSet?.weight ?? 0)
        weightLabel.text = weightString
    }
    
    private func fetchPRs() {
        
        fetchBest1RM()
        fetchBestVolume()
        fetchBestWeight()
        
    }
    
    private func fetchBest1RM() {
        
        let context = coreDataHelper.mainContext
        // Check add to 1RM PRs
        let setsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Set")
        setsFetchRequest.predicate = NSPredicate(format: "oneRepMaxPRExercise == %@", self.exercise!)
        setsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "oneRepMax", ascending: false)]
        
        do {
            best1RMSet = try context.fetch(setsFetchRequest).first as? Set
        } catch {
            print("Could not fetch 1RM pr sets \(error)")
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
    
    private func fetchBestVolume() {
        
        let context = coreDataHelper.mainContext
        // Check add to 1RM PRs
        let setsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Set")
        setsFetchRequest.predicate = NSPredicate(format: "volumePRExercise == %@", self.exercise!)
        setsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "volume", ascending: false)]
        
        do {
            bestVolumeSet = try context.fetch(setsFetchRequest).first as? Set
        } catch {
            print("Could not fetch volume pr sets \(error)")
        }
        
    }
    
    private func fetchBestWeight() {
        
        let context = coreDataHelper.mainContext
        // Check add to 1RM PRs
        let setsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Set")
        setsFetchRequest.predicate = NSPredicate(format: "maxWeightPRExercise == %@", self.exercise!)
        setsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "weight", ascending: false)]
        
        do {
            bestWeightSet = try context.fetch(setsFetchRequest).first as? Set
        } catch {
            print("Could not fetch weight pr sets \(error)")
        }
        
    }


}
