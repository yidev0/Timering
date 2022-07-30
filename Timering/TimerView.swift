//
//  TimerViews.swift
//  Timering
//
//  Created by Yuto on 2022/07/30.
//

import SwiftUI

struct TimerView: View {
    
    @Binding var timerType:TimerType
    
    var body: some View {
        ZStack{
            switch timerType {
            case .ring:
                RingTimerView()
            case .grid:
                GridTimerView()
            }
        }
    }
}

struct TimerViews_Previews: PreviewProvider {
    static var previews: some View {
        TimerViews()
    }
}
