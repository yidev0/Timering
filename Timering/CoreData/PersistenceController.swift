//
//  PersistenceController.swift
//  Timering
//
//  Created by Yuto on 2022/08/09.
//

import Foundation
import SwiftUI
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    #if DEBUG
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        for i in 0 ..< 3{
            let group = TRGroup(context: viewContext)
            group.title = "Group\(i+1)"
            group.icon = categorySymbols.randomElement()
            
            for j in 0..<3{
                let timer = TRTimer(context: viewContext)
                timer.title = "Timer\(i+j)"
                timer.icon = timerSymbols.randomElement()
                
                let entry = TREntry(context: viewContext)
                let startDate:Date = [.today, .iPhone(), .newYear()][j]
                entry.startDate = startDate
            }
            
            
            do {
                try viewContext.save()
            } catch {
                #if DEBUG
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                #else
                print(error.localizedDescription)
                #endif
            }
        }
        
        return result
    }()
    #endif

    let container: CustomPersistentContainer

    init(inMemory: Bool = false) {
        container = CustomPersistentContainer(name: "Timering")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
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
    }
}

