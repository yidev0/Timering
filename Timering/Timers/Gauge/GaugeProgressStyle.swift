//
//  GaugeProgressStyle.swift
//  Timering
//
//  Created by Yuto on 2023/03/01.
//

import SwiftUI

struct GaugeProgressStyle: ProgressViewStyle {
    
    var width = 20.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(TintShapeStyle(), style: StrokeStyle(lineWidth: width, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

extension ProgressViewStyle {
//    public static var gauge(color: Color = .blue, width: CGFloat = 20) = {
//        GaugeProgressStyle(color: color, width: width)
//    }
}

struct GaugeProgressStyle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(value: 0.3)
            .progressViewStyle(GaugeProgressStyle())
            .tint(.orange)
    }
}
