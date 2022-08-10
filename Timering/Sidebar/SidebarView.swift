//
//  SidebarView.swift
//  Timering
//
//  Created by Yuto on 2022/08/07.
//

import SwiftUI

struct SidebarView: View {
    
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
                        Label(group.title ?? "Untitled", image: group.icon ?? "folder")
                    }
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
        .navigationTitle("Timering")
    }
    
    init(){
        
    }
    
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
