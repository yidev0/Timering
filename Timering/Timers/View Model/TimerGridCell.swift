//
//  TimerGridCell.swift
//  Timering
//
//  Created by Yuto on 2023/02/27.
//

import SwiftUI

enum GridShape: Int{
    case defaultShape = 0, circle, square
}

struct TimerGridCell: View {
    
    var shape: GridShape = .defaultShape
    var title: String
    var icon: String
    var color: Color
    var rate: CGFloat
    var isActive: Bool = false
    var gaugeWidth: CGFloat = 8
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Image(systemName: icon)
                }
                .frame(height: UIFont.preferredFont(forTextStyle: .title1).pointSize)
                
                Text(title)
            }
            .foregroundColor(color)
            
            backgroundShape
                .foregroundColor(.fill)

            gaugeShape
                .foregroundColor(isActive ?  color :color.opacity(0.13))
                .padding(.all, gaugeWidth/2)
        }
    }
    
    var backgroundShape: some View {
        return GeometryReader { geometry in
            switch shape {
            case .defaultShape:
                GaugeRoundedRectangle(radius: geometry.size.height/12.8)
            case .circle:
                Circle()
            case .square:
                Rectangle()
            }
        }
    }
    
    var gaugeShape: some View {
        GeometryReader { geometry in
            switch shape {
            case .defaultShape:
                GaugeRoundedRectangle(radius: geometry.size.height/12.8)
                    .trim(from: 0.0, to: rate)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: gaugeWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
            case .circle:
                Circle()
                    .trim(from: 0.0, to: rate)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: gaugeWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
            case .square:
                Rectangle()
                    .trim(from: 0.0, to: rate)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: gaugeWidth,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
            }
        }
    }
    
}

struct TimerGridCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TimerGridCell(
                shape: .defaultShape,
                title: "Timer 1",
                icon: "timer",
                color: .blue,
                rate: 0.2
            )
            .frame(width: 200, height: 200)
            
            TimerGridCell(
                shape: .defaultShape,
                title: "Grid",
                icon: "tram",
                color: .orange,
                rate: 0.7,
                isActive: true
            )
            .frame(width: 200, height: 150)
            
            TimerGridCell(
                shape: .circle,
                title: "Grid",
                icon: "tram",
                color: .orange,
                rate: 0.7,
                isActive: true
            )
            .frame(width: 200, height: 150)
        }
        .previewLayout(.sizeThatFits)
    }
}
