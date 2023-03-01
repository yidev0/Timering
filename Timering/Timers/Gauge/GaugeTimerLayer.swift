//
//  TimerGaugeLayer.swift
//  Timering
//
//  Created by Yuto on 2023/03/01.
//

import SwiftUI

struct TimerGaugeLayer: View {
    
    var rate: Double
    var color: Color
    
    var body: some View {
        ProgressView(value: rate)
            .progressViewStyle(GaugeProgressStyle())
            .tint(color)
    }
}

struct TimerGaugeLayer_Previews: PreviewProvider {
    static var previews: some View {
        GaugeTimerLayer(rate: 0.33, color: .red)
            .frame(width: 200)
    }
}
