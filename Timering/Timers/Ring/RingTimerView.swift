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
    
    var group:TRGroup
    var fetchedTimers: FetchRequest<TRTimer>
    var trEntries: FetchRequest<TREntry>
    
//    @State var size:CGSize = .zero
    @State var counter:Double// = 0.001
//    @State var times:[Double] = []
//    @State var maxSize:Double = 100
    @State var startTime = Date()
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            RingView(group: group, entries: trEntries)
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
        self.group = group
        self.fetchedTimers = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TRTimer.title,
                                                                             ascending: true)],
                                          predicate: NSPredicate(format: "group == %@", group),
                                          animation: .default)
        self.trEntries = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TREntry.input,
                                                                         ascending: true)],
                                      predicate: NSPredicate(format: "timer.group == %@", group),
                                      animation: .default)
        self._counter = .init(initialValue: group.totalTime())
    }
    
}

//struct RingTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        RingTimerView()
//    }
//}
