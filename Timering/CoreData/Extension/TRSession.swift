//
//  TRSession.swift
//  Timering
//
//  Created by Yuto on 2023/02/28.
//

import Foundation

extension TRSession{
    var totalTime: Double {
        var returnValue:Double = 0.001
        if let timers = timers{
            for timer in timers{
                if let timer = timer as? TRTimer{
                    returnValue += timer.totalTime
                }
            }
        }
        return returnValue
    }
    
    func getTimers() -> [TRTimer] {
        if let array = self.timers?.allObjects.map({ $0 as! TRTimer}){
            return array
        } else {
            return []
        }
    }
    
    func checkActivity() -> Bool{
        if let timers = self.timers{
            for timer in timers{
                if let timer = timer as? TRTimer{
                    if timer.isActive {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func closeSession(withTimers: Bool = true) {
        let context = PersistenceController.shared.container.viewContext
        self.endDate = Date()
        self.isCompleted = true
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        let newSession = TRSession(context: context)
        newSession.createDate = Date()
        newSession.endDate = nil
        newSession.isCompleted = false
        newSession.group = self.group
        
        let timers = self.getTimers()
        for timer in timers {
            TimeringManager().newTimer(
                id: timer.timerID ?? UUID(),
                title: timer.title,
                icon: timer.icon,
                tint: timer.tint?.toUIColor(),
                goalTime: timer.goalTime,
                timeSensitive: timer.isTimeSensitive,
                session: newSession
            )
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
