//
//  TRGroup.swift
//  Timering
//
//  Created by Yuto on 2023/02/28.
//

import Foundation
import CoreData

extension TRGroup{
    func getActiveSession() -> TRSession?{
        if let sessions = self.sessions?.allObjects as? [TRSession], sessions.count != 0{
            if sessions.count == 1, let first = sessions.first{
                return first
            } else {
                return sessions.first(where: { $0.endDate == nil })
            }
        }
        return nil
    }
    
    func getSessions() -> [TRSession] {
        if let array = self.sessions?.allObjects.map({ $0 as! TRSession}){
            return array
        } else {
            return []
        }
    }
    
    func checkActivity() -> Bool{
        if let activeSession = getActiveSession(){
            if let timers = activeSession.timers{
                for timer in timers{
                    if let timer = timer as? TRTimer{
                        if timer.isActive {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func totalTime() -> Double{
        var returnValue:Double = 0.001
        if let activeSession = getActiveSession(){
            if let timers = activeSession.timers{
                for timer in timers{
                    if let timer = timer as? TRTimer{
                        returnValue += timer.totalTime
                    }
                }
            }
        }
        return returnValue
    }
    
    func overallTime() -> Double{
        var returnValue:Double = 0.001
        if let sessions = self.sessions?.allObjects as? [TRSession]{
            for session in sessions {
                if let timers = session.timers{
                    for timer in timers{
                        if let timer = timer as? TRTimer{
                            returnValue += timer.totalTime
                        }
                    }
                }
            }
        }
        return returnValue
    }
    
    func delete(){
        do {
            let viewContext = PersistenceController.shared.container.viewContext
            let sessions = try viewContext.fetch(NSFetchRequest<TRSession>(entityName: "TRSession")).filter({ $0.group == self })
            let timers = try viewContext.fetch(NSFetchRequest<TRTimer>(entityName: "TRTimer")).filter({ $0.session?.group == self })
            let entries = try viewContext.fetch(NSFetchRequest<TREntry>(entityName: "TREntry")).filter{
                if let timer = $0.timer{
                    return timers.contains(timer)
                }
                return false
            }
            sessions.forEach(viewContext.delete)
            timers.forEach(viewContext.delete)
            entries.forEach(viewContext.delete)
            viewContext.delete(self)
            
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
