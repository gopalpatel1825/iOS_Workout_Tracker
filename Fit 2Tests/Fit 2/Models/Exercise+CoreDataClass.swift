//
//  Exercise+CoreDataClass.swift
//  
//
//  Created by Gopal Patel on 3/21/25.
//
//

import Foundation
import CoreData

@objc(Exercise)
public class Exercise: NSManagedObject {
    
    let coreDataHelper = CoreDataHelper.shared
    
    func getLastWorkoutSets(context: NSManagedObjectContext) -> [Set] {
        
        let exerciseFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutExercise")
        exerciseFetchRequest.predicate = NSPredicate(format: "exercise == %@ AND template == nil", self)
        exerciseFetchRequest.sortDescriptors = [NSSortDescriptor(key: "workout.startDate", ascending: false)]
        
        do {
            let workoutExercises = try context.fetch(exerciseFetchRequest) as! [WorkoutExercise]
            if (workoutExercises.isEmpty) {
                return []
            } else {
                return workoutExercises.first!.sets?.array as! [Set]
            }
        } catch {
            print("Could not find last sets \(error)")
            return []
        }
    }
    
    
    func getLastTemplateSets(context: NSManagedObjectContext) -> [Set] {
        let exerciseFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WorkoutExercise")
        exerciseFetchRequest.predicate = NSPredicate(format: "exercise == %@ AND workout == nil", self)
        exerciseFetchRequest.sortDescriptors = [NSSortDescriptor(key: "totalVolume", ascending: false)]
        
        do {
            let workoutExercises = try context.fetch(exerciseFetchRequest) as! [WorkoutExercise]
            if (workoutExercises.isEmpty) {
                return []
            } else {
                return workoutExercises.first!.sets?.array as! [Set]
            }
        } catch {
            print("Could not find last sets \(error)")
            return []
        }
    }
    
    func addToPRs(set: Set) {
        // Check add to 1RM PRs
        addTo1RMPRs(set)
        // Check add to Volume PRs
        addToVolumePRs(set)
        // Check add to Weight PRs
        addToWeightPRs(set)
    }
    
    private func addTo1RMPRs(_ set: Set) {
        let context = coreDataHelper.workoutContext
        // Check add to 1RM PRs
        let setsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Set")
        setsFetchRequest.predicate = NSPredicate(format: "oneRepMaxPRExercise == %@", self)
        setsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "oneRepMax", ascending: false)]
        
        var sets: [Set] = []
        do {
            sets = try context.fetch(setsFetchRequest) as! [Set]
        } catch {
            print("Could not fetch 1RM pr sets \(error)")
        }
        
        if (sets.isEmpty) {
            self.addToOneRepMaxPRs(set)
        } else if (set.oneRepMax > sets.first!.oneRepMax) {
            self.addToOneRepMaxPRs(set)
        }
    }
    
    private func addToVolumePRs(_ set: Set) {
        let context = coreDataHelper.workoutContext
        // Check add to 1RM PRs
        let setsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Set")
        setsFetchRequest.predicate = NSPredicate(format: "volumePRExercise == %@", self)
        setsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "volume", ascending: false)]
        
        var sets: [Set] = []
        do {
            sets = try context.fetch(setsFetchRequest) as! [Set]
        } catch {
            print("Could not fetch 1RM pr sets \(error)")
        }
        
        if (sets.isEmpty) {
            self.addToMaxVolumePRs(set)
        } else if (set.oneRepMax > sets.first!.oneRepMax) {
            self.addToMaxVolumePRs(set)
        }
    }
    
    private func addToWeightPRs(_ set: Set) {
        let context = coreDataHelper.workoutContext
        // Check add to 1RM PRs
        let setsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Set")
        setsFetchRequest.predicate = NSPredicate(format: "maxWeightPRExercise == %@", self)
        setsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "weight", ascending: false)]
        
        var sets: [Set] = []
        do {
            sets = try context.fetch(setsFetchRequest) as! [Set]
        } catch {
            print("Could not fetch 1RM pr sets \(error)")
        }
        
        if (sets.isEmpty) {
            self.addToMaxWeightPRs(set)
        } else if (set.oneRepMax > sets.first!.oneRepMax) {
            self.addToMaxWeightPRs(set)
        }
    }

}

struct BaseExercise: Codable {
    
    var name: String
    var category: String
    var bodyPart: String
    var mediaFileName: String?
    var summary: [String]
}

