//
//  RingView.swift
//  Timering
//
//  Created by Yuto on 2022/08/12.
//

import SwiftUI

struct RingView: View{
    
    @AppStorage("RingPlayVibration", store: userDefaults) var vibrate = false
    
    @State var counter:Double
    var entries:FetchRequest<TREntry>
    @State var maxSize:Double = 100
    
    var body: some View{
        GeometryReader { geometry in
            ZStack{
                Circle()
                    .hidden()
                //                    .foregroundColor(.random)
                    .frame(width: maxSize, height: maxSize, alignment: .center)
                
                ForEach(entries.wrappedValue, id: \.self) { entry in
                    Circle()
                        .frame(width: entry.sum(entries: entries.wrappedValue)/counter * maxSize, alignment: .center)
                        .aspectRatio(1, contentMode: .fill)
                        .foregroundColor(Color(entry.timer?.tint as? UIColor ?? .random))
                        .onAppear{
                            print("Appear",
                                  String(format: "%.2f", entry.sum(entries: entries.wrappedValue)),
                                  "+",
                                  String(format: "%.2f", counter),
                                  String(format: "%.2f", entry.timer!.session!.totalTime()))
                        }
                        .onChange(of: entry.value) { _ in
                            print("Change",
                                  String(format: "%.2f", entry.sum(entries: entries.wrappedValue)),
                                  "+",
                                  String(format: "%.2f", counter),
                                  String(format: "%.2f", entry.timer!.session!.totalTime()))
                            if let session = entry.timer?.session{
                                withAnimation {
                                    counter = session.totalTime()
                                }
                            }
                        }
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
    
    init(group:TRGroup, entries:FetchRequest<TREntry>){
        self._counter = .init(initialValue: group.totalTime())
        self.entries = entries
        //TODO: Entries not updated
    }
    
}
