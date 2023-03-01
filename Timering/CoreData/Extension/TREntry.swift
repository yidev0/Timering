//
//  TREntry.swift
//  Timering
//
//  Created by Yuto on 2023/02/28.
//

import Foundation
import SwiftUI

extension TREntry{
    /// Total time of entry
    /// Returns 0 if there is not startDate set
    var totalTime: Double {
        if let start = self.startDate {
            let end = self.endDate ?? Date()
            let value = end.timeIntervalSince(start)
            return value
        }
        return 0
    }
    
    func sum(entries:[TREntry]) -> Double {
        var returnValue:Double = 0
        if let index = entries.firstIndex(of: self){
            for i in index..<entries.count{
                returnValue += entries[i].totalTime
            }
        }
//        print("Ring Entry Sum: ", self.value, returnValue, self.timer?.totalTime())
        return returnValue
    }
    
    func sum(entries:FetchedResults<TREntry>) -> Double {
        var returnValue:Double = 0
        if let index = entries.firstIndex(of: self){
            for i in index..<entries.count{
                returnValue += entries[i].totalTime
            }
        }
//        print("Ring Entry Sum: ", self.value, returnValue, self.timer?.totalTime())
        return returnValue
    }
}
