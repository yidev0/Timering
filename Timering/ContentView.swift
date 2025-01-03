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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact{
//            NavigationView{
                TabBarView()
//            }.navigationViewStyle(.stack)
        } else {
            NavigationView {
                SidebarView()
                Text("")
            }
            .navigationViewStyle(.columns)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
