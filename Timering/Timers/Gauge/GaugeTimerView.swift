//
//  GaugeTimerView.swift
//  Timering
//
//  Created by Yuto on 2022/08/08.
//

import SwiftUI

struct GaugeTimerView: View {
    var trGroup:TRGroup
    var trSession:TRSession
    var fetchedTimers: FetchRequest<TRTimer>

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                ForEach(fetchedTimers.wrappedValue, id: \.self){ timer in
                    ProgressView(value: fillRate(of: timer), total: timer.goalTime)
                       .progressViewStyle(GaugeProgressStyle(color: Color(timer.tint as! UIColor)))
                       .labelsHidden()
                       .frame(width: gaugeSize(of: timer, size: geometry.size),
                              height: gaugeSize(of: timer, size: geometry.size))
                       .onAppear{
                           print(timer.totalTime, timer.goalTime, timer.totalTime.remainder(dividingBy: timer.goalTime))
                       }
                }
            }
        }
    }
    
    init(group:TRGroup){
        self.trGroup = group
        self.trSession = group.getActiveSession()!
        self.fetchedTimers = FetchRequest(sortDescriptors: [],
                                          predicate: NSPredicate(format: "session == %@", trSession),
                                          animation: .default)
    }
    
    func gaugeSize(of timer:TRTimer, size: CGSize) -> CGFloat{
        let index = fetchedTimers.wrappedValue.firstIndex(of: timer) ?? 0
        let minFrame = size.height < size.width ? size.height:size.width
        return (minFrame / CGFloat(fetchedTimers.wrappedValue.count) + 4) * CGFloat(index)
    }
    
    func fillRate(of timer: TRTimer) -> CGFloat {
        let remainder = timer.totalTime.remainder(dividingBy: timer.goalTime)
        return remainder < 0 ? (timer.goalTime + remainder):remainder
    }
}

struct GaugeProgressStyle: ProgressViewStyle {
    var color = Color.blue
    var width = 20.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(color, style: StrokeStyle(lineWidth: width, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

//struct GaugeTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        GaugeTimerView()
//    }
//}
