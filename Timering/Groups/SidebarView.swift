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
    @State var newGroup = false
    @State var sheetSession:TRSession?
    
    var body: some View {
        List{
            NavigationLink {
                OverviewView()
            } label: {
                Label("Sidebar.Section.Overview", systemImage: "timer")
            }
            
            Section{
                ForEach(groups) { group in
                    GroupListCell(group: group, popGroup: $popGroup, sheetSession: $sheetSession)
                }
            } header: {
                Text("Sidebar.Section.Groups")
            }
            .sheet(item: $popGroup){ group in
                GroupDetailView(group: group)
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Timering")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack{
                    Button {
                        newGroup = true
                    } label: {
                        Image(systemName: "folder.badge.plus")
                    }
                    .sheet(isPresented: $newGroup) {
                        GroupDetailView(group: nil)
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
    
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
