//
//  OverviewView.swift
//  Timering
//
//  Created by Yuto on 2022/08/18.
//

import SwiftUI

struct OverviewView: View {
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    let column = [GridItem(.adaptive(minimum: (375-32-8),
                                     maximum: (420-32)),
                           spacing: 8)]
    
    var trGroups:FetchRequest<TRGroup>
    @State var showSettings = false
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: column, spacing: 8) {
                Section {
                    ForEach(0..<3) { i in
                        OverviewTotalGrid(type: [.overall, .today, .session][i])
                    }
                }
                
                OverviewGroupSection()
            }
            .padding(.horizontal, 16)
            
            Spacer()
                .frame(height: sizeClass == .compact ? 120:0)
        }
        .navigationTitle(Text("Sidebar.Section.Overview"))
        .background(Color.background)
        .toolbar {
            ToolbarItem {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
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
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    init(){
        self.trGroups = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TRGroup.title,
                                                                        ascending: true)],
                                     animation: .default)
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
