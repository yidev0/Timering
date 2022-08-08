//
//  SidebarView.swift
//  Timering
//
//  Created by Yuto on 2022/08/07.
//

import SwiftUI

struct SidebarView: View {
    
    @State var timerType:TimerType
    
    var body: some View {
        List{
            NavigationLink {
                
            } label: {
                Label("Sidebar.Section.Overview", systemImage: "timer")
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
                Text("Sidebar.Section.Groups")
            }
        }
        .listStyle(.sidebar)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack{
                    Button {
                        
                    } label: {
                        HStack(spacing: 8){
                            Image(systemName: "plus.circle.fill")
                            Text("Sidebar.Button.NewGroup")
                        }
                    }
                    
                    Spacer()
                }
            }
            
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if UIDevice.current.userInterfaceIdiom == .phone{
                    EditButton()
                }
            }
        }
        .navigationTitle("Timering")
    }
    
    init(){
        self.timerType = TimerType(rawValue: userDefaults?.integer(forKey: "TimerType") ?? 0)!
    }
    
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
