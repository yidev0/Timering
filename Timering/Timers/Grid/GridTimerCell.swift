//
//  GridTimerDetail.swift
//  Timering
//
//  Created by Yuto on 2022/08/10.
//

import SwiftUI
import AVKit

struct GridTimerCell:View{
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("GridPlayVibration", store: userDefaults) var vibrate = true
    @AppStorage("GridPlayType", store: userDefaults) var soundType = 0
    @AppStorage("GridShape", store: userDefaults) var shape = 0
    
    @State var audioPlayer:AVAudioPlayer?
    
    @State var trTimer:TRTimer
    var fetchedEntry: FetchRequest<TREntry>
    
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @Binding var itemSize:CGSize
    
    @State var isAdjusting = false
    @State var showTools = true
    @State var startTime = Date()
    
    @State var totalValue:Double
    
    var cellID = UUID().uuidString
    
    var gauge: some View{
        ZStack{
            VStack(alignment: .center, spacing: 12){
                Label(trTimer.title ?? "Untitled",
                      systemImage: trTimer.icon ?? "folder")
                    .foregroundColor(Color((trTimer.tint as? UIColor) ?? .systemBlue))
                    .multilineTextAlignment(.center)
                Text("\(totalValue, specifier: "%.2f")")
                    .foregroundColor(Color((trTimer.tint as? UIColor) ?? .systemBlue))
                    .multilineTextAlignment(.center)
            }

            switch GridShape(rawValue: shape)!{
            case .defaultShape:
                RoundedRectangle(cornerRadius: itemSize.height/12.8)
                    .foregroundColor(Color(.systemFill))
            case .circle:
                Circle()
                    .foregroundColor(Color(.systemFill))
            case .square:
                Rectangle()
                    .foregroundColor(Color(.systemFill))
            }

            switch GridShape(rawValue: shape)!{
            case .defaultShape:
                RoundedRectangle(cornerRadius: itemSize.height/25.6)
                    .trim(from: 0.0, to: (totalValue.truncatingRemainder(dividingBy: trTimer.goalTime))/trTimer.goalTime)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(trTimer.isActive ?  Color((trTimer.tint as? UIColor) ?? .systemBlue):Color(.secondarySystemFill))
                    .rotationEffect(Angle(degrees: 270.0))
                    .padding(.all, 4)
            case .circle:
                Circle()
                    .trim(from: 0.0, to: (totalValue.truncatingRemainder(dividingBy: trTimer.goalTime))/trTimer.goalTime)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(trTimer.isActive ?  Color((trTimer.tint as? UIColor) ?? .systemBlue):Color(.secondarySystemFill))
                    .rotationEffect(Angle(degrees: 270.0))
                    .padding(.all, 4)
            case .square:
                Rectangle()
                    .trim(from: 0.0, to: (totalValue.truncatingRemainder(dividingBy: trTimer.goalTime))/trTimer.goalTime)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(trTimer.isActive ?  Color((trTimer.tint as? UIColor) ?? .systemBlue):Color(.secondarySystemFill))
                    .rotationEffect(Angle(degrees: 270.0))
                    .padding(.all, 4)
            }
        }
    }
    
    var body: some View{
        ZStack{
            Button {
                buttonPressed()
            } label: {
                gauge
                    .onReceive(timer) { output in
                        withAnimation {
                            totalValue = trTimer.totalTime
                        }
                    }
            }
            .buttonStyle(.plain)
            .frame(width: itemSize.width, height: itemSize.height, alignment: .center)
            
            if showTools{
                GridToolView(trTimer: $trTimer, fetchedEntry: fetchedEntry)
                    .padding(.all, 8)
            }
        }
        .frame(width: itemSize.width, height: itemSize.height, alignment: .center)
        .contextMenu{
            Button {
//                showInfo()
            } label: {
                Label("Timer.Button.ShowInfo", systemImage: "info")
            }
            
            Button(role: .destructive) {
                stopTimer()
                viewContext.delete(trTimer)
                try? viewContext.save()
            } label: {
                Label("Timer.Button.Delete", systemImage: "trash")
            }
        }
        .onAppear{
//            stopTimer()
        }
    }
    
    init(timer: TRTimer, size:Binding<CGSize>){
        self._trTimer = /*State<TRTimer>*/.init(initialValue: timer)
        self.fetchedEntry = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \TREntry.startDate,
                                                                            ascending: true)],
                                         predicate: NSPredicate(format: "timer == %@", timer),
                                         animation: .default)
        self._itemSize = size
        self._totalValue = .init(initialValue: timer.totalTime)
    }
    
    func buttonPressed(){
//        trTimer.isActive.toggle()
//        showTools = !trTimer.isActive
//        
//        if trTimer.isActive{
//            let newEntry = TREntry(context: viewContext)
//            newEntry.input = Date()
//            newEntry.value = 0
//            newEntry.timer = trTimer
//            do{
//                try viewContext.save()
//            } catch {
//                print(error.localizedDescription)
//            }
//        } else {
//            
//        }
//        
//        trTimer.isActive == false ? stopTimer():startTimer()
    }
    
    func stopTimer() {
        print("stop")
//        self.timer.upstream.connect().cancel()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [cellID])
        
        do{
            try viewContext.save()
        } catch {
            #if DEBUG
            fatalError("Save Failed: GridTimerCell")
            #else
            print(error.localizedDescription)
            #endif
        }
    }
    
    func startTimer() {
        print("start")
        self.timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        
        let content = UNMutableNotificationContent()
        content.interruptionLevel = .timeSensitive
        content.title = trTimer.title ?? "Untitled"
        content.body = "Timer Completed"
        if soundType == 1{
            content.sound = UNNotificationSound.default
        } else if soundType >= 2{
            let soundNames = ["AUDIO_0004", "AUDIO_5242", "AUDIO_6413", "AUDIO_7063", "AUDIO_8166"]
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundNames[soundType - 2] + ".m4a"))
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: trTimer.goalTime, repeats: false)
        let request = UNNotificationRequest(identifier: cellID, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func completed(){
        trTimer.isActive = false
        showTools = true
        stopTimer()
        
        if soundType == 1{
            AudioServicesPlayAlertSound(SystemSoundID(1322))
        } else if soundType != 0{
            let soundNames = ["AUDIO_0004", "AUDIO_5242", "AUDIO_6413", "AUDIO_7063", "AUDIO_8166"]
            if let soundFileURL = Bundle.main.path(forResource: "\(soundNames[soundType - 2]).m4a", ofType: nil){
                do{
                    try AVAudioSession.sharedInstance().setCategory(
                        AVAudioSession.Category.playback,
                        options: AVAudioSession.CategoryOptions.duckOthers
                    )
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFileURL))
                    audioPlayer?.play()
                } catch {
                    print(error)
                }
            }
        }
        
        if vibrate{
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
}
