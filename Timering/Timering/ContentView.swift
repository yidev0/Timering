//
//  ContentView.swift
//  Timering
//
//  Created by Yuto on 2022/03/31.
//

import SwiftUI

enum TimerType:Int{
    case ring, grid
}

struct ContentView: View {
    
    @State var showSettings = false
    @State var timerType:TimerType
    
    var body: some View {
        NavigationView {
            ZStack{
                switch timerType {
                case .ring:
                    RingTimerView()
                case .grid:
                    GridTimerView()
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(timerType: $timerType)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if #available(iOS 15.0, *) {
                        Menu {
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
                        } primaryAction: {
                            showSettings = true
                        }
                        .accessibilityLabel(Text("Settings"))
                    } else {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                        .accessibilityLabel(Text("Settings"))
                        .contextMenu{
                            Picker(selection: $timerType) {
                                Label("Settings.Title.Ring", systemImage: "circle.circle")
                                    .tag(TimerType.ring)
                                Label("Settings.Title.Grid", systemImage: "square.grid.2x2")
                                    .tag(TimerType.grid)
                            } label: {
                                Text("Settings.Title.TimerType")
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: timerType) { newValue in
                userDefaults?.set(timerType.rawValue, forKey: "TimerType")
            }
        }
        .navigationViewStyle(.stack)
    }
    
    init(){
        self.timerType = TimerType(rawValue: userDefaults?.integer(forKey: "TimerType") ?? 0)!
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
