//
//  RingView.swift
//  Timering
//
//  Created by Yuto on 2022/08/12.
//

import SwiftUI

struct RingView: View{
    
    @AppStorage("DynamicRing", store: userDefaults) var dynamicRing = true
    @AppStorage("RingPlayVibration", store: userDefaults) var vibrate = false
    @AppStorage("RingLimitTime", store: userDefaults) var limit = 30.0
    @AppStorage("RingSetTime", store: userDefaults) var setLimit = true
    
    @Binding var counter:Double
    var entries:[TREntry]
    @State var maxSize:Double = 100
    
    var body: some View{
        GeometryReader { geometry in
            ZStack{
                Circle()
                    .hidden()
//                    .foregroundColor(.random)
                    .frame(width: maxSize, height: maxSize, alignment: .center)
                
                ForEach(entries, id: \.self) { entry in
                    Circle()
                        .ignoresSafeArea()
                        .frame(width: entry.value/(setLimit ? (dynamicRing ? counter:limit):counter) * maxSize, alignment: .center)
                        .aspectRatio(1, contentMode: .fill)
                        .foregroundColor(Color(entry.timer?.tint as? UIColor ?? .random))
                }
            }
            .offset(x: (geometry.size.width < geometry.size.height) ? -(geometry.size.height - geometry.size.width)/2:0,
                    y: (geometry.size.width > geometry.size.height) ? -(geometry.size.width  - geometry.size.height)/2:0)
            .onChange(of: geometry.size) { newValue in
                maxSize = (newValue.width > newValue.height) ? newValue.width:newValue.height
            }
            .onAppear {
                maxSize = (geometry.size.width > geometry.size.height) ? geometry.size.width:geometry.size.height
            }
        }
    }
    
    init(counter: Binding<Double>, entries:FetchRequest<TREntry>, timers:FetchRequest<TRTimer>){
        self._counter = counter
        self.entries = entries.wrappedValue.filter({
            if let timer = $0.timer{
                return (timers.wrappedValue.contains(timer) == true)
            }
            return false
        })
    }
    
}
