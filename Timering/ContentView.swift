//
//  ContentView.swift
//  Timering
//
//  Created by Yuto on 2022/03/31.
//

import SwiftUI

enum TimerType:Int{
    case ring, grid, gauge
}

struct ContentView: View {
    
    @State var timerType:TimerType
    
    var body: some View {
        NavigationView {
            SidebarView()
            
            ZStack{
                TimerView(timerType: $timerType)
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
