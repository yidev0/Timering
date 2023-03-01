//
//  TRTimer.swift
//  Timering
//
//  Created by Yuto on 2023/02/28.
//

import Foundation

extension TRTimer{
    func allEntries() -> [TREntry] {
        if let array = self.entries?.allObjects.map({ $0 as! TREntry}){
            return array
        } else {
            return []
        }
    }
    
    var completionRate: Double {
        return self.totalTime.truncatingRemainder(dividingBy: self.goalTime)/self.goalTime
    }
    
    var totalTime: Double {
        var returnValue:Double = 0.001
        if let entries = entries{
            for entry in entries{
                if let entry = entry as? TREntry{
                    returnValue += entry.totalTime
                }
            }
        }
        return returnValue
    }
    
    func startTimer() {
        let context = PersistenceController.shared.container.viewContext
        let newEntry = TREntry(context: context)
        newEntry.startDate = Date()
        newEntry.timer = self
        
        do {
            try context.save()
            self.isActive = true
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func stopTimer() {
        if let entry = self.newestEntry {
            entry.endDate = Date()
        }
        self.isActive = false
        
        do {
            let context = PersistenceController.shared.container.viewContext
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete() {
        let viewContext = PersistenceController.shared.container.viewContext
        let entries = self.allEntries()
        for entry in entries {
            viewContext.delete(entry)
        }
        
        viewContext.delete(self)
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // TODO: check sort
    var oldestEntry: TREntry? {
        self.allEntries().sorted(by: { $0.startDate ?? Date() < $1.startDate ?? Date() }).first!
    }
    
    var newestEntry: TREntry? {
        self.allEntries().sorted(by: { $0.startDate ?? Date() > $1.startDate ?? Date() }).first
    }
}
