//
//  Shapes.swift
//  Timering
//
//  Created by Yuto on 2023/03/01.
//

import SwiftUI

struct GaugeRoundedRectangle: Shape {
    
    var radius: CGFloat = 10
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(
            x: rect.midX,
            y: rect.minY)
        )
        
        path.addLine(to: CGPoint(
            x: rect.maxX - radius,
            y: rect.minY)
        )
        
        path.addArc(center:
                        CGPoint(x: rect.maxX - radius,
                                y: rect.minY + radius),
                    radius: radius,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        
        path.addLine(to: CGPoint(
            x: rect.maxX,
            y: rect.maxY - radius)
        )
        
        path.addArc(center:
                        CGPoint(x: rect.maxX - radius,
                                y: rect.maxY - radius),
                    radius: radius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        
        path.addLine(to: CGPoint(
            x: rect.minX + radius,
            y: rect.maxY)
        )
        
        path.addArc(center:
                        CGPoint(x: rect.minX + radius,
                                y: rect.maxY - radius),
                    radius: radius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        
        path.addLine(to: CGPoint(
            x: rect.minX,
            y: rect.minY + radius)
        )
        
        path.addArc(center:
                        CGPoint(x: rect.minX + radius,
                                y: rect.minY + radius),
                    radius: radius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        
        path.addLine(to: CGPoint(
            x: rect.midX,
            y: rect.minY)
        )

        return path
    }
}

struct Shapes_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.gray)
                .frame(width: 200, height: 120)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .trim(from: 0, to: 0.5)
                        .stroke(lineWidth: 2)
                }
            GaugeRoundedRectangle(radius: 10)
                .foregroundColor(.gray)
                .frame(width: 200, height: 120)
                .overlay {
                    GaugeRoundedRectangle(radius: 10)
                        .trim(from: 0, to: 0.5)
                        .stroke(lineWidth: 2)
                }
        }
    }
}
