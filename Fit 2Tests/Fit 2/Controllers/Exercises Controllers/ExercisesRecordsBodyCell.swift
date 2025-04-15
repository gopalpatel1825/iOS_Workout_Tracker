//
//  ExercisesRecordsBodyCell.swift
//  Fit 2
//
//  Created by Gopal Patel on 3/27/25.
//

import UIKit

class ExercisesRecordsBodyCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var exercise: Exercise?
    
    var sets: [Set] = []
    
    var is1RM: Bool = false
    
    var isVolume: Bool = false
    
    var isWeight: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ExerciseRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "ExerciseRecordTableViewCell")
    }
    
    func configureFor1RM() {
        sets = exercise!.oneRepMaxPRs!.array as! [Set]
        is1RM = true
        titleLabel.text = "1RM"
        tableView.reloadData()
    }
    
    func configureForVolume() {
        sets = exercise!.maxVolumePRs!.array as! [Set]
        isVolume = true
        titleLabel.text = "Volume"
        tableView.reloadData()
    }
    
    func configureForWeight() {
        sets = exercise!.maxWeightPRs!.array as! [Set]
        isWeight = true
        titleLabel.text = "Weight"
        tableView.reloadData()
    }

}

extension ExercisesRecordsBodyCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseRecordTableViewCell", for: indexPath) as! ExerciseRecordTableViewCell
        
        cell.set = sets[indexPath.row]
        
        if (is1RM) {
            cell.configureFor1RM()
        } else if (isVolume) {
            cell.configureForVolume()
        } else {
            cell.configureForWeight()
        }
        
        return cell
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
