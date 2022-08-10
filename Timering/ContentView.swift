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
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var timerType:TimerType
    
    var body: some View {
        NavigationView {
            SidebarView()
            
//            ZStack{
//                TimerView()
//            }
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
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
