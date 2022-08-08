//
//  TimerViews.swift
//  Timering
//
//  Created by Yuto on 2022/07/30.
//

import SwiftUI

struct TimerView: View {
    
    @State var showSettings = false
    @Binding var timerType:TimerType
    
    var body: some View {
        ZStack{
            switch timerType {
            case .ring:
                RingTimerView()
            case .grid:
                GridTimerView()
            case .gauge:
                RingTimerView()
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(timerType: $timerType)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu{
                    Button {
                        showSettings = true
                    } label: {
                        Text("Settings.OpenSettings")
                    }
                    
                    Picker(selection: $timerType) {
                        Label("Settings.Title.Ring", systemImage: "circle.circle")
                            .tag(TimerType.ring)
                        Label("Settings.Title.Grid", systemImage: "square.grid.2x2")
                            .tag(TimerType.grid)
                    } label: {
                        Text("Settings.Title.TimerType")
                    }
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        
    }
}

struct TimerView_Previews: PreviewProvider {
    
    @State static var timerType:TimerType = .ring
    
    static var previews: some View {
        TimerView(timerType: $timerType)
    }
}
