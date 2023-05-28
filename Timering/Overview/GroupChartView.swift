//
//  GroupChartView.swift
//  Timering
//
//  Created by Yuto on 2022/08/29.
//

import SwiftUI
import Charts

struct GroupChartView: View {
    
    var trGroup: TRGroup
    
    var body: some View {
        GroupBox {
            Chart {
                ForEach(trGroup.getSessions(), id: \.id) { session in
                    BarMark(x: .value("Session", session.createDate?.toString() ?? "aa"),
                            y: .value("Time", session.totalTime))
                }
            }
            .onAppear {
                print(trGroup.getSessions().count)
            }
        } label: {
            Label(trGroup.title ?? "Untitled".localize(),
                  systemImage: trGroup.icon ?? "timer")
        }
    }
}

//struct GroupChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupChartView()
//    }
//}
