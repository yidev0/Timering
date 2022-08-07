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
            List{
                NavigationLink {
                    
                } label: {
                    Label("Overview", systemImage: "timer")
                }
                
                Section{
                    NavigationLink {
                        TimerView(timerType: $timerType)
                    } label: {
                        Label("School", systemImage: "graduationcap")
                    }
                    
                    NavigationLink {
                        TimerView(timerType: $timerType)
                    } label: {
                        Label("Work", systemImage: "briefcase")
                    }
                } header: {
                    Text("Timers")
                }
            }.listStyle(.sidebar)
            
            ZStack{
                switch timerType {
                case .ring:
                    RingTimerView()
                case .grid:
                    GridTimerView()
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(timerType: $timerType)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: timerType) { newValue in
            userDefaults?.set(timerType.rawValue, forKey: "TimerType")
        }
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
