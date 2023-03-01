//
//  TRSession.swift
//  Timering
//
//  Created by Yuto on 2023/02/28.
//

import Foundation

extension TRSession{
    func totalTime() -> Double{
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
}
