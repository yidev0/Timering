//
//  GaugeTimerView.swift
//  Timering
//
//  Created by Yuto on 2022/08/08.
//

import SwiftUI

struct GaugeTimerView: View {
//    
//    @State var timers:[TRTimer] = testTimers
//    
    var body: some View {
        GaugeView()
    }
}

struct GaugeView: View{
//    
//    var gaugeTimer:TRTimer
//    
    var body: some View{
        Circle()
//            .trim(from: 0.0, to: gaugeTimer.times.reduce(0, +).truncatingRemainder(dividingBy: gaugeTimer.goalTime)/gaugeTimer.goalTime)
//            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
//            .foregroundColor(gaugeTimer.tint)
//            .rotationEffect(Angle(degrees: -90))
//            .padding(.all, 4)
    }
}

struct GaugeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        GaugeTimerView()
    }
}
