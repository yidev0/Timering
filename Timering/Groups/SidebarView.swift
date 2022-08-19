//
//  SidebarView.swift
//  Timering
//
//  Created by Yuto on 2022/08/07.
//

import SwiftUI

struct GroupListCell: View{
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var group:TRGroup
    @Binding var popGroup:TRGroup?
    @Binding var sheetSession:TRSession?
    
    var LinkCell: some View{
        NavigationLink {
            TimerView(group: group)
        } label: {
            Label(group.title ?? "Untitled", systemImage: group.icon ?? "folder")
        }
    }
    
    var ButtonCell: some View{
        Button {
            sheetSession = group.getActiveSession()
        } label: {
            Label(title: { Text(group.title ?? "Untitled").foregroundColor(.primary) },
                  icon: { Image(systemName: group.icon ?? "folder") })
        }
    }
    
    var TrashButton: some View{
        Button(role: .destructive) {
            group.delete()
        } label: {
            Label("Sidebar.Button.Delete", systemImage: "trash")
        }
    }
    
    var DetailButton: some View{
        Button {
            popGroup = group
        } label: {
            Label("Sidebar.Button.ShowDetail", systemImage: "info.circle")
        }
    }
    
    var body: some View{
        Group{
            if horizontalSizeClass == .compact{
                ButtonCell
            } else {
                LinkCell
            }
        }
        .swipeActions {
            TrashButton
            DetailButton
        }
        .contextMenu{
            DetailButton
            TrashButton
        }
    }
}

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

struct GroupListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var groups:FetchedResults<TRGroup>
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var timers:FetchedResults<TRTimer>
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var entries:FetchedResults<TREntry>
    
    @State var popGroup:TRGroup?
    @Binding var sheetSession:TRSession?
    @State var showSettings = false
    @State var newGroup = false
    
    var body: some View {
        List{
            Section{
                ForEach(groups) { group in
                    GroupListCell(group: group, popGroup: $popGroup, sheetSession: $sheetSession)
                }
            }
            .sheet(item: $popGroup){ group in
                GroupDetailView(group: group)
            }
            
            Section{
                Button {
                    newGroup = true
                } label: {
                    Label("Sidebar.Button.NewGroup", systemImage: "folder.badge.plus")
                }
            }
            .sheet(isPresented: $newGroup) {
                GroupDetailView(group: nil)
            }
        }
        .navigationTitle("Timering")
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    EditButton()
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gear")
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
