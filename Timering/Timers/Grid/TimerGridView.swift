//
//  TimerGridView.swift
//  Timering
//
//  Created by Yuto on 2023/02/28.
//

import SwiftUI

struct TimerGridView: View {
    
    let columns = [GridItem(
        .adaptive(
            minimum: 169.5,
            maximum: 202
        ),
        spacing: 8)]
    
    var trTimers: FetchRequest<TRTimer>
    var trGroup: TRGroup?
    var trSession: TRSession?
    
    init(group: TRGroup?){
        self.trGroup = group
        self.trSession = group?.getActiveSession()
        if let session = trSession {
            self.trTimers = FetchRequest(
                sortDescriptors: [],
                predicate: NSPredicate(format: "session == %@", session),
                animation: .default
            )
        } else {
            self.trTimers = FetchRequest(
                sortDescriptors: [],
//                predicate: NSPredicate(format: "session.isCompleted == %@", false),
                animation: .default
            )
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(trTimers.wrappedValue, id: \.self) { timer in
                TimerGridButton(trTimer: timer)
                    .aspectRatio(trGroup == nil ? 1.414:1, contentMode: .fit)
            }
        }
    }
}

struct TimerGridView_Previews: PreviewProvider {
    static var previews: some View {
        TimerGridView(group: nil)
    }
}
