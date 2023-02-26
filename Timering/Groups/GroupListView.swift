//
//  GroupListView.swift
//  Timering
//
//  Created by Yuto on 2023/02/26.
//

import SwiftUI

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

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListView(sheetSession: .constant(nil))
    }
}
