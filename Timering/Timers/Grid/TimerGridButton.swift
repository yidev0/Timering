//
//  TimerGridButton.swift
//  Timering
//
//  Created by Yuto on 2023/02/27.
//

import SwiftUI

struct TimerGridButton: View {
    
    @State var isActive: Bool
    var trTimer: TRTimer
    
    init(trTimer: TRTimer) {
        self.isActive = trTimer.isActive
        self.trTimer = trTimer
    }
    
    var body: some View {
        Menu {
            Button(role: .destructive) {
                trTimer.delete()
            } label: {
                Label("Delete from session", systemImage: "trash")
            }
            
            Button(role: .destructive) {
                trTimer.delete()
            } label: {
                Label("Delete All", systemImage: "trash.fill")
            }
        } label: {
            TimerGridCell(
                title: trTimer.title ?? "Untitled".localize(),
                icon: trTimer.icon ?? "",
                color: trTimer.tint?.toColor() ?? .blue,
                rate: trTimer.completionRate,
                isActive: trTimer.isActive
            )
        } primaryAction: {
            buttonPressed()
        }
        .onChange(of: trTimer.isActive) { newValue in
            isActive = newValue
        }
    }
    
    func buttonPressed(){
        trTimer.isActive ? trTimer.stopTimer():trTimer.startTimer()
    }
    
}

//struct TimerGridButton_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerGridButton(trTimer: <#TRTimer#>)
//    }
//}
