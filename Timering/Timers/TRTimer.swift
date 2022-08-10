//
//  TRTimer.swift
//  Timering
//
//  Created by Yuto on 2022/08/08.
//

import Foundation
import SwiftUI

//TODO: CoreDataに移行
//class TRTimer: Identifiable, Equatable{
//    static func == (lhs: TRTimer, rhs: TRTimer) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
//    var title:String
//    var icon:String
//    
//    var id:String
//    var groupID:String
//    
//    var isActive:Bool = false
//    var lastInput:[Date] = []
//    var times:[Double] = []
//    var goalTime:Double
//    
//    var tint:Color
//    var isTimeSensitive = false
//    
//    init(title:String, icon:String, groupID:String, goalTime:Double, tint:Color){
//        self.id = UUID().uuidString
//        self.groupID = groupID
//        
//        self.title = title
//        self.icon = icon
//        
//        self.goalTime = goalTime
//        self.tint = tint
//    }
//    
//    func toRingTimer() -> [RingTimer]{
//        return []
//    }
//}
//
//var testTimers = [TRTimer(title: "aaa", icon: "camera", groupID: "1", goalTime: 10, tint: .blue),
//                  TRTimer(title: "bbb", icon: "car", groupID: "1", goalTime: 10, tint: .cyan),
//                  TRTimer(title: "ccc", icon: "figure.walk", groupID: "1", goalTime: 10, tint: .mint),
//                  TRTimer(title: "ddd", icon: "tortoise", groupID: "1", goalTime: 10, tint: .teal)]
//
//var testTimers2 = [TRTimer(title: "eee", icon: "hare", groupID: "1", goalTime: 10, tint: .red),
//                   TRTimer(title: "fff", icon: "hifispeaker", groupID: "1", goalTime: 10, tint: .orange),
//                   TRTimer(title: "ggg", icon: "ferry", groupID: "1", goalTime: 10, tint: .yellow),
//                   TRTimer(title: "hhh", icon: "bicycle", groupID: "1", goalTime: 10, tint: .pink)]
