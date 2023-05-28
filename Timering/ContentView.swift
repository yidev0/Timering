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
            NavigationSplitView {
                SidebarView()
            } detail: {
                Text("")
            }
            .navigationViewStyle(.columns)
        }
    }
    
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
#endif
