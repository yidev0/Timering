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
    
    var body: some View {
        TabView(selection: $selection) {
            ActiveSessionBar(selectedSession: $selectedSession, sheetSession: $sheetSession){
                OverviewView()
            }
            .tag(0)
            .tabItem {
                Label("Tabbar.Section.Overview", systemImage: "timer")
            }
            
            ActiveSessionBar(selectedSession: $selectedSession, sheetSession: $sheetSession){
                CompactListView(sheetSession: $sheetSession)
            }
            .tag(1)
            .tabItem {
                Label("Tabbar.Section.Groups", systemImage: "square.grid.2x2.fill")
            }
        }
        .sheet(item: $sheetSession) { session in
            if let group = session.group{
                //TODO: iOS 16
                if #available(iOS 16.0, *) {
                    TimerView(group: group)
                        .presentationDetents([.medium, .large])
                } else {
                    TimerView(group: group)
                }
            }
        }
        .onChange(of: sheetSession) { newValue in
            if newValue != nil{
                selectedSession = newValue
            }
        }
    }
}

struct ActiveSessionBar<Content: View>: View{
    
    @Binding var selectedSession:TRSession?
    @Binding var sheetSession:TRSession?
    
    var content: () -> Content
    
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var isPressed = false
    @State var totalValue = 0.0
    
    @ViewBuilder var body: some View{
        ZStack(alignment: .bottom) {
            NavigationView{
                content()
            }
            
            VStack(spacing: 0){
                Spacer()
                
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
                                        totalValue = trSession.totalTime()
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
                .background(.ultraThinMaterial)
                
                Divider()
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
