//
//  Set+CoreDataClass.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/4/25.
//
//

import Foundation
import CoreData

@objc(Set)
public class Set: NSManagedObject {
    
    var modified: Bool = false
    
    var previousReps: Int64? = nil
    
    var previousWeight: Double? = nil
    
    func calculateStatistics() {
        calculateVolume()
        calculate1RM()
    }
    
    private func calculateVolume() {
        let volume = Float(Double(reps) * weight)
        self.volume = Double(volume)
    }

    
    private func calculate1RM() {
        let oneRM = self.weight * (1 + Double((Double(self.reps)/30)))
        self.oneRepMax = oneRM
    }
}
