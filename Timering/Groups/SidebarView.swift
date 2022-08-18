//
//  SidebarView.swift
//  Timering
//
//  Created by Yuto on 2022/08/07.
//

import SwiftUI

struct SidebarView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var groups:FetchedResults<TRGroup>
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var timers:FetchedResults<TRTimer>
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var entries:FetchedResults<TREntry>
    
    @State var popGroup:TRGroup?
    
    var body: some View {
        List{
            NavigationLink {
                OverviewView()
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
                }.onDelete(perform: deleteGroup(offsets:))
            } header: {
                Text("Sidebar.Section.Groups")
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Timering")
        .popover(item: $popGroup){ group in
            //TODO: グループの詳細表示画面
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack{
                    Button {
                        let newGroup = TRGroup(context: viewContext)
                        newGroup.title = "Group \(Int.random(in: 0..<100))"
                        newGroup.timerType = 1
                        newGroup.icon = categorySymbols.randomElement()
                        
                        let newSession = TRSession(context: viewContext)
                        newSession.group = newGroup
                        newSession.createDate = Date()
                        
                        try? viewContext.save()
                    } label: {
//                        HStack(alignment: .center, spacing: 8){
//                            Image(systemName: "plus.circle.fill")
//                            Text("Sidebar.Button.NewGroup")
//                        }
                        Image(systemName: "folder.badge.plus")
                    }
                    
                    Spacer()
                }
            }
            
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if horizontalSizeClass == .compact{
                    Menu {
                        EditButton()
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
    
    init(){
        
    }
    
    func deleteGroup(offsets: IndexSet){
        offsets.map { groups[$0] }.forEach{ group in
            group.delete()
        }
    }
    
}

struct GroupListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var groups:FetchedResults<TRGroup>
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var timers:FetchedResults<TRTimer>
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var entries:FetchedResults<TREntry>
    
    @State var popGroup:TRGroup?
    @Binding var sheetSession:TRSession?
    
    var body: some View {
        List{
            Section{
                ForEach(groups) { group in
                    Button {
                        sheetSession = group.getActiveSession()
                    } label: {
                        Label(group.title ?? "Untitled", systemImage: group.icon ?? "folder")
                    }
                }.onDelete(perform: deleteGroup(offsets:))
            } header: {
                Text("Sidebar.Section.Groups")
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Timering")
        .popover(item: $popGroup){ group in
            //TODO: グループの詳細表示画面
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if horizontalSizeClass == .compact{
                    Menu {
                        EditButton()
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
    
    func deleteGroup(offsets: IndexSet){
        offsets.map { groups[$0] }.forEach{ group in
            group.delete()
        }
    }
    
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
