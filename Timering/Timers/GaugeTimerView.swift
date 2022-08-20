//
//  GaugeTimerView.swift
//  Timering
//
//  Created by Yuto on 2022/08/08.
//

import SwiftUI

class GaugeTimer:Hashable{
    static func == (lhs: GaugeTimer, rhs: GaugeTimer) -> Bool {
        return lhs.value == rhs.value && lhs.icon == rhs.icon && lhs.tint == rhs.tint && lhs.goal == rhs.goal
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(icon)
        hasher.combine(tint)
        hasher.combine(goal)
    }
    
    var value:Double    //秒数
    var icon:String     //アイコン
    var tint:Color      //色
    var goal:Double     //目標時間
    
    init(value: Double, icon: String, tint: Color, goal: Double) {
        self.value = value
        self.icon = icon
        self.tint = tint
        self.goal = goal
    }
}

//TODO: 仮のタイマー
//実験で4つにした
let testGaugeTimers = [GaugeTimer(value: Double(Int.random(in: 1..<100)),
                                  icon: timerSymbols.randomElement() ?? "car",
                                  tint: .random,
                                  goal: 80),
                       GaugeTimer(value: Double(Int.random(in: 1..<100)),
                                  icon: timerSymbols.randomElement() ?? "car",
                                  tint: .random,
                                  goal: 80),
                       GaugeTimer(value: Double(Int.random(in: 1..<100)),
                                  icon: timerSymbols.randomElement() ?? "car",
                                  tint: .random,
                                  goal: 80),
                       GaugeTimer(value: Double(Int.random(in: 1..<100)),
                                  icon: timerSymbols.randomElement() ?? "car",
                                  tint: .random,
                                  goal: 80)]

struct GaugeTimerView: View {
    var timers:[GaugeTimer]

    var body: some View {
        ZStack{
            ForEach(timers, id: \.self){timer in
                GaugeView(trTimer: timer, timers: timers)
            }
        }
        
    }
}

struct GaugeView: View{
    var trTimer:GaugeTimer
    var timers: [GaugeTimer]
    var width:CGFloat = 12
    
    var body: some View{
        Circle()
            .trim(from: 0, to: (trTimer.value)/(trTimer.goal))
            .stroke(style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round))
            .foregroundColor(trTimer.tint)
            .rotationEffect(Angle(degrees: -90))
            .padding(.all, 4)
            .frame(width:  100 + (width*3) * CGFloat(timers.firstIndex(of: trTimer) ?? 0),
                   height: 100 + (width*3) * CGFloat(timers.firstIndex(of: trTimer) ?? 0))
    }
}

struct GaugeTimerView_Previews: PreviewProvider {
    static var previews: some View {
        GaugeTimerView(timers: testGaugeTimers)
    }
}
