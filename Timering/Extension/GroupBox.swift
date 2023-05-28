//
//  GroupBox.swift
//  Timering
//
//  Created by Yuto on 2023/03/03.
//

import SwiftUI

struct ColorGroupBox: GroupBoxStyle {
    
    var hideLabel = false
    var color:Color
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            if !hideLabel{
                HStack {
                    configuration.label
                        .font(.headline)
                    Spacer()
                }
            }
            
            configuration.content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(color)) // Set your color here!!
    }
}
