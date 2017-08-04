//
//  AppDelegate.swift
//  Journal
//
//  Created by 蘇冠禎 on 2017/8/4.
//  Copyright © 2017年 蘇冠禎. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let themeColor = UIColor.white

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window?.tintColor = themeColor
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Post")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                
                print(CoreDataError.loadPersistentStoreFailed)
                
                // Todo: remember to delete fatalError later
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
            } catch (let error) {
                
                print(CoreDataError.saveContextFailed)
                
                // Todo: remember to delete fatalError later
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

enum CoreDataError: Error {
    case loadPersistentStoreFailed
    case saveContextFailed
    case incompleteData
}

