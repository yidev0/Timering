//
//  TimerGaugeView.swift
//  Timering
//
//  Created by Yuto on 2022/08/08.
//

import SwiftUI

struct TimerGaugeView: View {
    
    var trGroup:TRGroup
    var trSession:TRSession
    var fetchedTimers: FetchRequest<TRTimer>
    
    init(group:TRGroup){
        self.trGroup = group
        self.trSession = group.getActiveSession()!
        self.fetchedTimers = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "session == %@", trSession),
            animation: .default
        )
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                ForEach(fetchedTimers.wrappedValue, id: \.self){ timer in
                    TimerGaugeLayer(rate: timer.completionRate, color: timer.tint?.toColor() ?? .blue)
                        .frame(
                            width: gaugeSize(of: timer, size: geometry.size),
                            height: gaugeSize(of: timer, size: geometry.size)
                        )
                }
            }
            .frame(
                width: geometry.frame(in: .global).width,
                height: geometry.frame(in: .global).height
            )
        }
        .padding()
    }
    
    func gaugeSize(of timer:TRTimer, size: CGSize) -> CGFloat{
        let index = fetchedTimers.wrappedValue.firstIndex(of: timer) ?? 0
        let minFrame = size.height < size.width ? size.height:size.width
        let count = fetchedTimers.wrappedValue.count < 4 ? 4:fetchedTimers.wrappedValue.count
        return (minFrame / CGFloat(count) + 4) * CGFloat(index + 1)
    }
}

//struct GaugeTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        GaugeTimerView()
//    }
//}
