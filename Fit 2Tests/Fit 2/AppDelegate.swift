//
//  AppDelegate.swift
//  Fit 2
//
//  Created by Gopal Patel on 1/30/25.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        preloadBaseExercisesIfNeeded()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Fit_2")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func preloadBaseExercisesIfNeeded() {
        print("called preload exercises")
        let hasImported = UserDefaults.standard.bool(forKey: "didPreloadExercises")
        guard !hasImported else { return }
        
        preloadArmsExercises()
        preloadBackExercises()
        preloadChestExercises()
        preloadLegsExercises()
        preloadShouldersExercises()

        UserDefaults.standard.set(true, forKey: "didPreloadExercises")
    }
    
    
    func preloadArmsExercises() {
        guard let url = Bundle.main.url(forResource: "ArmsExercises", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let parsed = try? JSONDecoder().decode([BaseExercise].self, from: data) else {
            print("Failed to load exercises.json")
            return
        }

        let context = CoreDataHelper.shared.mainContext
        for base in parsed {
            let exercise = Exercise(context: context)
            exercise.name = base.name
            exercise.category = base.category
            exercise.bodyPart = base.bodyPart
            exercise.mediaFileName = base.mediaFileName
            let stepStrings = base.summary
            
            for string in stepStrings {
                let step = Step(context: context)
                step.details = string
                exercise.addToSteps(step)
            }
        }

        do {
            try context.save()
        } catch {
            print("could not load arm exercises: \(error)")
        }
    }
    
    func preloadBackExercises() {
        guard let url = Bundle.main.url(forResource: "BackExercises", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let parsed = try? JSONDecoder().decode([BaseExercise].self, from: data) else {
            print("Failed to back exercises.json")
            return
        }

        let context = CoreDataHelper.shared.mainContext
        for base in parsed {
            let exercise = Exercise(context: context)
            exercise.name = base.name
            exercise.category = base.category
            exercise.bodyPart = base.bodyPart
            exercise.mediaFileName = base.mediaFileName
            let stepStrings = base.summary
            
            for string in stepStrings {
                let step = Step(context: context)
                step.details = string
                exercise.addToSteps(step)
            }
        }

        do {
            try context.save()
        } catch {
            print("could not load arm exercises: \(error)")
        }
    }
    
    func preloadChestExercises() {
        guard let url = Bundle.main.url(forResource: "ChestExercises", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let parsed = try? JSONDecoder().decode([BaseExercise].self, from: data) else {
            print("Failed to chest exercises.json")
            return
        }

        let context = CoreDataHelper.shared.mainContext
        for base in parsed {
            let exercise = Exercise(context: context)
            exercise.name = base.name
            exercise.category = base.category
            exercise.bodyPart = base.bodyPart
            exercise.mediaFileName = base.mediaFileName
            let stepStrings = base.summary
            
            for string in stepStrings {
                let step = Step(context: context)
                step.details = string
                exercise.addToSteps(step)
            }
        }

        do {
            try context.save()
        } catch {
            print("could not load arm exercises: \(error)")
        }
        
    }
    
    func preloadLegsExercises() {
        guard let url = Bundle.main.url(forResource: "LegsExercises", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let parsed = try? JSONDecoder().decode([BaseExercise].self, from: data) else {
            print("Failed to leg exercises.json")
            return
        }

        let context = CoreDataHelper.shared.mainContext
        for base in parsed {
            let exercise = Exercise(context: context)
            exercise.name = base.name
            exercise.category = base.category
            exercise.bodyPart = base.bodyPart
            exercise.mediaFileName = base.mediaFileName
            let stepStrings = base.summary
            
            for string in stepStrings {
                let step = Step(context: context)
                step.details = string
                exercise.addToSteps(step)
            }
        }

        do {
            try context.save()
        } catch {
            print("could not load arm exercises: \(error)")
        }
        
    }
    
    func preloadShouldersExercises() {
        guard let url = Bundle.main.url(forResource: "ShouldersExercises", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let parsed = try? JSONDecoder().decode([BaseExercise].self, from: data) else {
            print("Failed to shooulder exercises.json")
            return
        }

        let context = CoreDataHelper.shared.mainContext
        for base in parsed {
            let exercise = Exercise(context: context)
            exercise.name = base.name
            exercise.category = base.category
            exercise.bodyPart = base.bodyPart
            exercise.mediaFileName = base.mediaFileName
            let stepStrings = base.summary
            
            for string in stepStrings {
                let step = Step(context: context)
                step.details = string
                exercise.addToSteps(step)
            }
        }

        do {
            try context.save()
        } catch {
            print("could not load arm exercises: \(error)")
        }
        
    }


}

