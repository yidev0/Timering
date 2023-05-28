//
//  TabBarView.swift
//  Timering
//
//  Created by Yuto on 2022/08/18.
//

import SwiftUI

struct TabBarView: View {
    
    @State var selectedSession:TRSession?
    @State var sheetSession:TRSession?
    @State var selection = 1
    
    @State var allowFullPlayer = false
    
    var body: some View {
        TabView(selection: $selection) {
            ActivityView(allowFullScreen: $allowFullPlayer) {
                OverviewView()
            } player: {
                ZStack {
                    if let group = sheetSession?.group {
                        TimerView(group: group)
                    } else {
                        Text("Error")
                    }
                }
            } label: {
                label
            }
            .tag(0)
            .tabItem {
                Label("Tabbar.Section.Overview", systemImage: "timer")
            }
            
            ActivityView(allowFullScreen: $allowFullPlayer) {
                CompactListView(sheetSession: $sheetSession)
            } player: {
                ZStack {
                    if let group = sheetSession?.group {
                        TimerView(group: group)
                    } else {
                        Text("Error")
                    }
                }
            } label: {
                label
            }
            .tag(1)
            .tabItem {
                Label("Tabbar.Section.Groups", systemImage: "square.grid.2x2.fill")
            }
        }
        .onChange(of: sheetSession) { newValue in
            allowFullPlayer = (sheetSession != nil)
            if newValue != nil{
                selectedSession = newValue
            }
        }
        .onAppear {
            allowFullPlayer = (sheetSession != nil)
        }
    }
    
    var label: some View {
        PlayerCellView(
            symbol: selectedSession?.group?.icon ?? "exclamationmark.triangle.fill",
            imageColor: .blue,
            title:
                (sheetSession == nil) ? "Select Group":selectedSession?.group?.title ?? "Untitled".localize(),
            subtitle:
                (sheetSession == nil) ? nil:selectedSession?.group?.title ?? "Untitled".localize(),
            value: selectedSession?.totalTime ?? 0
        )
    }
}

struct ActiveSessionBar<Content: View>: View{
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedSession:TRSession?
    @Binding var sheetSession:TRSession?
    
    var content: () -> Content
    
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var isPressed = false
    @State var totalValue = 0.0
    
    @ViewBuilder var body: some View{
        ZStack(alignment: .bottom) {
            NavigationStack {
                content()
            }
            
            VStack(spacing: 0){
                Spacer()
                
                VStack(spacing: 0) {
                    Button {
                        sheetSession = selectedSession
                    } label: {
                        HStack{
                            if let trSession = selectedSession{
                                Image(systemName: trSession.group?.icon ?? "questionmark")
                            }
                            
                            VStack(alignment: .leading){
                                if let trSession = selectedSession{
                                    Text(trSession.group?.title ?? "Untitled")
                                } else {
                                    Text("N/A")
                                }
                                if let trSession = selectedSession{
                                    Text("\(totalValue, specifier: "%.2f")")
                                        .foregroundColor(.secondary)
                                        .font(.footnote)
                                        .onReceive(timer) { _ in
                                            totalValue = trSession.totalTime
                                            //TODO: 時間差を計算
                                        }
                                }
                            }
                            Spacer()
                            
                            if let isActive = selectedSession?.checkActivity(){
                                Image(systemName: isActive ? "play.fill":"pause.fill")
                            }
                        }
                    }
                    .padding()
                    
                    Divider()
                }
                .background(.regularMaterial)
                .shadow(color: .gray.opacity(colorScheme == .dark ? 0:0.4), radius: 2, y: -2)
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
