//
//  CoreData + Extensions.swift
//  Timering
//
//  Created by Yuto on 2022/08/13.
//

import Foundation
import CoreData
import SwiftUI

extension TRTimer{
    func toEntries() -> [TREntry] {
        if let array = self.entries?.allObjects.map({ $0 as! TREntry}){
            return array
        } else {
            return []
        }
    }
    
    func totalTime() -> Double{
        var returnValue:Double = 0.001
        if let entries = entries{
            for entry in entries{
                if let entry = entry as? TREntry{
                    returnValue += entry.value
                }
            }
        }
        return returnValue
    }
    
    func adjustTime(){
        if self.isActive == true {
            let currentTime = Date()
            let entries = self.toEntries().sorted(by: { $0.input ?? Date() < $1.input ?? Date() })
            if let entry = entries.last, let startDate = entry.input{
                let dif = currentTime.timeIntervalSince(startDate)
                let adjustTime = dif - entry.value
                if adjustTime > 0{
                    print("dif", String(format: "%.2f", adjustTime))
                    entry.value += adjustTime
                }
                entry.value += 0.01
            }
        }
    }
}

extension TRGroup{
    func totalTime() -> Double{
        var returnValue:Double = 0.001
        if let timers = timers{
            for timer in timers{
                if let timer = timer as? TRTimer{
                    returnValue += timer.totalTime()
                }
            }
        }
        return returnValue
    }
    
    func delete(){
        do {
            let viewContext = PersistenceController.shared.container.viewContext
            let timers = try viewContext.fetch(NSFetchRequest<TRTimer>(entityName: "TRTimer")).filter({ $0.group == self })
            let entries = try viewContext.fetch(NSFetchRequest<TREntry>(entityName: "TREntry")).filter{
                if let timer = $0.timer{
                    return timers.contains(timer)
                }
                return false
            }
            
            timers.forEach(viewContext.delete)
            entries.forEach(viewContext.delete)
            viewContext.delete(self)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension TREntry{
    func sum(entries:[TREntry]) -> Double {
        var returnValue:Double = 0
        if let index = entries.firstIndex(of: self){
            for i in index..<entries.count{
                returnValue += entries[i].value
            }
        }
//        print("Ring Entry Sum: ", self.value, returnValue, self.timer?.totalTime())
        return returnValue
    }
    
    func sum(entries:FetchedResults<TREntry>) -> Double {
        var returnValue:Double = 0
        if let index = entries.firstIndex(of: self){
            for i in index..<entries.count{
                returnValue += entries[i].value
            }
        }
//        print("Ring Entry Sum: ", self.value, returnValue, self.timer?.totalTime())
        return returnValue
    }
}
