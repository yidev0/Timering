//
//  RingTimerView.swift
//  Timering
//
//  Created by Yuto on 2022/03/31.
//

import SwiftUI

struct RingTimerView: View {
    
    @AppStorage("RingPlayVibration", store: userDefaults) var vibrate = false
    
    @State var showSettings = false
    @State var isActive = false
    @State var isAdjusting = false
    
    var trGroup:TRGroup
    var trSession:TRSession
    var fetchedTimers: FetchRequest<TRTimer>
    var trEntries: FetchRequest<TREntry>
    
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            RingView(group: trGroup, entries: trEntries)
                .ignoresSafeArea()
        }
        .onTapGesture {
            print(trEntries.wrappedValue.count)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onReceive(timer) { output in
            for timer in fetchedTimers.wrappedValue{
                timer.adjustTime()
            }
        }
    }
    
    init(group:TRGroup){
        self.trGroup = group
        self.trSession = group.getActiveSession()!
        self.fetchedTimers = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TRTimer.title,
                                                                             ascending: true)],
                                          predicate: NSPredicate(format: "session == %@", trSession),
                                          animation: .default)
        self.trEntries = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TREntry.input,
                                                                         ascending: true)],
                                      predicate: NSPredicate(format: "timer.session == %@", trSession),
                                      animation: .default)
    }
    
}

//struct RingTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        RingTimerView()
//    }
//}
