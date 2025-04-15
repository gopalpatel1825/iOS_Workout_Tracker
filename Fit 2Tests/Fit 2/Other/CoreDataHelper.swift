//
//  DataManager.swift
//  Fit 2
//
//  Created by Gopal Patel on 2/3/25.
//
import UIKit
import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    lazy var mainContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    lazy var baseExerciseContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var templateContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var workoutContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var historyContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = mainContext
        return privateContext
    }()
    
    func saveMainContext() {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                print("Error saving main managed object context: \(error)")
            }
        }
    }
    
    private func savePrivateContext() {
        if privateManagedObjectContext.hasChanges {
            do {
                try privateManagedObjectContext.save()
            } catch {
                print("Error saving private managed object context: \(error)")
            }
        }
    }
    
    func saveGivenContext(context: NSManagedObjectContext) {
        context.performAndWait {
            if (context.hasChanges) {
                do {
                    try context.save()
                } catch {
                    print("Failed to save context: \(error)")
                }
            }
        }
    }
    
    private func saveChanges() {
        savePrivateContext()
        mainContext.performAndWait {
            saveMainContext()
        }
    }
    
    /*private func mergeChangesFromPrivateContext() {
        mainManagedObjectContext.performAndWait {
            do {
                try mainManagedObjectContext.save()
            } catch {
                print("Error saving main managed object context after merging changes: \(error)")
            }
        }
    }*/
    
    func saveData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.perform {
            // Insert the objects into the private context
            for object in objects {
                self.privateManagedObjectContext.insert(object)
            }
            
            // Save changes to the private context and merge to the main context
            self.savePrivateContext()
        }
    }
    
//    func updateData<T: NSManagedObject>(objects: [T]) {
//        privateManagedObjectContext.perform {
//            // Update the objects in the private context
//            for object in objects {
//                if object.managedObjectContext == self.privateManagedObjectContext {
//                    // If the object is already in the private context, update it directly
//                    object.managedObjectContext?.refresh(object, mergeChanges: true)
//                } else {
//                    // If the object is not in the private context, fetch and update it
//                    let fetchRequest = NSFetchRequest<T>(entityName: object.entity.name!)
//                    fetchRequest.predicate = NSPredicate(format: "SELF == %@", object)
//                    fetchRequest.fetchLimit = 1
//                    
//                    if let fetchedObject = try? self.privateManagedObjectContext.fetch(fetchRequest).first {
//                        fetchedObject.setValuesForKeys(object.dictionaryWithValues(forKeys: object.entity.attributesByName.keys.map { $0.rawValue }))
//                    }
//                }
//            }
//            
//            // Save changes to the private context and merge to the main context
//            self.saveChanges()
//        }
//    }
    
    func deleteData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.perform {
            // Delete the objects from the private context
            for object in objects {
                if object.managedObjectContext == self.privateManagedObjectContext {
                    self.privateManagedObjectContext.delete(object)
                } else {
                    if let objectInContext = self.privateManagedObjectContext.object(with: object.objectID) as? T {
                        self.privateManagedObjectContext.delete(objectInContext)
                    }
                }
            }
            
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
}
