//
//  TimeringManager.swift
//  Timering
//
//  Created by Yuto on 2023/03/01.
//

import UIKit

class TimeringManager {
    
    func newGroup(
        title: String?,
        icon: String?,
        timerType: Int16 = 0
    ) {
        let viewContext = PersistenceController.shared.container.viewContext
        let newGroup = TRGroup(context: viewContext)
        newGroup.title = title
        newGroup.icon = icon
        newGroup.timerType = timerType
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func newSession(
        createDate: Date,
        endDate: Date? = nil,
        isCompleted: Bool = false
    ) {
        let viewContext = PersistenceController.shared.container.viewContext
        let newSession = TRSession(context: viewContext)
        newSession.createDate = createDate
        newSession.endDate = endDate
        newSession.isCompleted = isCompleted
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func newTimer(
        id: UUID,
        title: String?,
        icon: String?,
        tint: UIColor?,
        goalTime: Double,
        isActive: Bool = false,
        timeSensitive: Bool = false,
        session: TRSession? = nil
    ) {
        let viewContext = PersistenceController.shared.container.viewContext
        let newTimer = TRTimer(context: viewContext)
        newTimer.timerID = id
        newTimer.title = title
        newTimer.icon = icon
        newTimer.tint = tint
        newTimer.goalTime = goalTime
        newTimer.isActive = isActive
        newTimer.isTimeSensitive = timeSensitive
        newTimer.session = session
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func newEntry(
        startDate: Date,
        endDate: Date? = nil
    ) {
        let viewContext = PersistenceController.shared.container.viewContext
        let newEntry = TREntry(context: viewContext)
        newEntry.startDate = startDate
        newEntry.endDate = endDate
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
