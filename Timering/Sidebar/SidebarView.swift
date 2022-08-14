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
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var timers:FetchedResults<TRTimer>
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var entries:FetchedResults<TREntry>
    
    @State var popGroup:TRGroup?
    
    var body: some View {
        List{
            NavigationLink {
                //TODO: 
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
        .navigationTitle("Timering")
        .listStyle(.sidebar)
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
