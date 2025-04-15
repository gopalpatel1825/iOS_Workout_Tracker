//
//  WorkoutExercise+CoreDataClass.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/3/25.
//
//

import Foundation
import CoreData

@objc(WorkoutExercise)
public class WorkoutExercise: NSManagedObject {
    
    func calculateVolume() -> Float {
        
        var total:Float = 0
        
        for sets in self.sets! {
            let aset = sets as! Set
            aset.calculateStatistics()
            total += Float(aset.volume)
        }
        
        return total
        
    }
    
}
