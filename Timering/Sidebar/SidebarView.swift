//
//  SidebarView.swift
//  Timering
//
//  Created by Yuto on 2022/08/07.
//

import SwiftUI

struct SidebarView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var groups:FetchedResults<TRGroup>
    
    var body: some View {
        List{
            NavigationLink {
                
            } label: {
                Label("Sidebar.Section.Overview", systemImage: "timer")
            }
            
            Section{
                ForEach(groups) { group in
                    NavigationLink {
                        TimerView(group: group)
                    } label: {
                        Label(group.title ?? "Untitled", systemImage: group.icon ?? "folder")
                    }
                }
            } header: {
                Text("Sidebar.Section.Groups")
            }
        }
        .navigationTitle("Timering")
        .listStyle(.sidebar)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack{
                    Button {
                        let newGroup = TRGroup(context: viewContext)
                        newGroup.title = "Group\(Int.random(in: 0..<100))"
                        newGroup.timerType = 1
                        newGroup.icon = categorySymbols.randomElement()
                        try? viewContext.save()
                    } label: {
                        HStack(alignment: .center, spacing: 8){
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
    }
    
    init(){
        
    }
    
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
