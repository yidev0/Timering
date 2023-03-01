//
//  CompactListView.swift
//  Timering
//
//  Created by Yuto on 2023/01/24.
//

import SwiftUI

struct CompactListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var groups:FetchedResults<TRGroup>
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var timers:FetchedResults<TRTimer>
    @FetchRequest(sortDescriptors: [], predicate: nil, animation: .default) var entries:FetchedResults<TREntry>
    
    @State var viewType:ListViewType = .timers
    @State var popGroup:TRGroup?
    @Binding var sheetSession:TRSession?
    @State var showSettings = false
    @State var newGroup = false
    
    @State var gridItems = [GridItem(.adaptive(minimum: (375 - 32 - 12) / 2), spacing: 8, alignment: .center)]
    @State var itemSize = CGSize(width: 100, height: 100)
    
    var body: some View {
        GeometryReader { geometry in
            switch viewType {
            case .timers:
                ScrollView {
                    TimerGridView(group: nil)
                }
                .onChange(of: geometry.size) { newValue in
                    calculateGrid(size: newValue)
                }
                .onAppear{
                    calculateGrid(size: geometry.size)
                }
            case .groups:
                List{
                    Section{
                        ForEach(groups) { group in
                            GroupListCell(group: group, popGroup: $popGroup, sheetSession: $sheetSession)
                        }
                        .listRowBackground(Color.groupedBackground)
                    }
                    .sheet(item: $popGroup){ group in
                        GroupDetailView(group: group)
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .background(Color.background)
            }
        }
        .navigationTitle(viewType == .timers ? "Timer.Type.Timers":"Timer.Type.Groups")
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $newGroup) {
            GroupDetailView(group: nil)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gear")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Picker(selection: $viewType) {
                        Label("Timer.Type.Timers", systemImage: "timer").tag(ListViewType.timers)
                        Label("Timer.Type.Groups", systemImage: "square.grid.2x2").tag(ListViewType.groups)
                    } label: {
                        Image(systemName: viewType == .timers ? "timer":"square.grid.2x2")
                    }
                    
                    Button {
                        newGroup = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    func calculateGrid(size:CGSize){
        withAnimation {
            let orientation:DeviceOrientation = size.width > size.height ? .horizontal:.vertical
            var horizontalCount:CGFloat = 0
            var verticalCount:CGFloat = 0
            horizontalCount = (orientation == .horizontal) ? 3:2
            verticalCount   = (orientation == .horizontal) ? 2:3
            
            let spacing:CGFloat = 8
            let width = (size.width - (spacing*2) - spacing * (horizontalCount - 1)) / horizontalCount
            let height = (size.height - (spacing*2) - spacing * (verticalCount - 1)) / verticalCount
            let size = width > height ? height:width
            itemSize = CGSize(width: size, height: size)
            gridItems = [GridItem](repeating: GridItem(.fixed(size), spacing: spacing, alignment: .center), count: Int(horizontalCount))
        }
    }
}

struct CompactListView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationStack {
            CompactListView(sheetSession: .constant(nil))
        }
    }
}
