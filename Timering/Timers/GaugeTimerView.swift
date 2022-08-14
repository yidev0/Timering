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
let testGaugeTimers = [GaugeTimer(value: Double(Int.random(in: 1..<100)),
                                  icon: timerSymbols.randomElement() ?? "car",
                                  tint: .random,
                                  goal: 15),
                       GaugeTimer(value: Double(Int.random(in: 1..<100)),
                                  icon: timerSymbols.randomElement() ?? "car",
                                  tint: .random,
                                  goal: 15)]

struct GaugeTimerView: View {
    
    var timers:[GaugeTimer]
    
    var body: some View {
        ForEach(timers, id: \.self) { timer in
            GaugeView(trTimer: timer)
        }
    }
}

struct GaugeView: View{
    
    var trTimer:GaugeTimer
    
    var body: some View{
        //TODO: タイマーの表示、大きさなどの計算を作る
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
        GaugeTimerView(timers: testGaugeTimers)
    }
}
