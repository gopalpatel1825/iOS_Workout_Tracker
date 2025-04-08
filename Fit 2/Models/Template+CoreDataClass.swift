//
//  Template+CoreDataClass.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/3/25.
//
//

import Foundation
import CoreData

@objc(Template)
public class Template: NSManagedObject {
    
    lazy var coreDataHelper: CoreDataHelper = {
        return CoreDataHelper.shared
    }()
    
    func initializeWorkout(workout: Workout) {
        
        let template = self
        
        // Turn the exercises into an array that we can iterate over
        let exercises = template.exercises?.array as? [WorkoutExercise] ?? []
        
        for exercise in exercises {
            
            // Make a new exercise in the workout context and set the base exercise
            let newExercise = WorkoutExercise(context: coreDataHelper.workoutContext)
            newExercise.exercise = exercise.exercise
            
            // Make an array of the sets that we can iterate over
            for aset in exercise.sets?.array as? [Set] ?? [] {
                // Make a new set in the workout context and make all of the properties equal
                let newSet = Set(context: coreDataHelper.workoutContext)
//                newSet.previousWeight = aset.weight
//                newSet.previousReps = aset.reps
                newSet.index = aset.index
                // Add the set to the exercise and add the exercise to the set
                newSet.exercise = newExercise
                newExercise.addToSets(newSet)
            }
            // Add the exercise to the workout
            workout.addToExercises(newExercise)
        }
        template.addToWorkouts(workout)
        workout.template = template
    }
    
}
