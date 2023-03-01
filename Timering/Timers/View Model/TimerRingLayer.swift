//
//  TimerRingLayer.swift
//  Timering
//
//  Created by Yuto on 2023/02/28.
//

import SwiftUI

struct TimerRingLayer: View {
    
    var title: String
    var color: Color
    var value: Double?
    
    var body: some View {
        Circle()
            .foregroundColor(color)
        // TODO: Label ring
            .accessibilityLabel("")
    }
}

struct TimerRingView_Previews: PreviewProvider {
    static var previews: some View {
        TimerRingLayer(
            title: "Title",
            color: .red,
            value: 0
        )
    }
}
