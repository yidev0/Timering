//
//  GridTimerView.swift
//  Timering
//
//  Created by Yuto on 2022/03/31.
//

import SwiftUI
import AVKit
import UserNotifications

class GridTimer: Identifiable{
    var id:String
    var title:String
    var time:Double
    var maxTime:Double
    var isActive:Bool
    var isTimeSensitive = true
    var tint:Color = .blue
    
    init(title:String, time:Double, isActive:Bool){
        self.id = UUID().uuidString
        self.title = title
        self.time = time
        self.maxTime = time
        self.isActive = isActive
    }
}

class GridTimerValue: ObservableObject{
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
}

enum GridShape: Int{
    case defaultShape = 0, circle, square
}

struct GridTimerView: View {
    
    @AppStorage("GridAutoPlay", store: userDefaults) var autoPlay = false
    
    @State var gridItems:[GridItem] = [GridItem(.fixed(100), spacing: 8, alignment: .center)]
    @State var timers:[GridTimer] = []
    @State var itemSize = CGSize(width: 100, height: 100)
    @State var spacing:CGFloat = 8
    
    @State var timerCount = 1
    
    let gridLimit = UIDevice.current.userInterfaceIdiom == .phone ? 8:12
    @State var orientation:DeviceOrientation = UIDevice.current.userInterfaceIdiom == .phone ? .vertical:.horizontal
    @State var showTimer:GridTimer? = nil
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center){
//                ScrollView{
                    LazyVGrid(columns: gridItems, spacing: spacing) {
                        ForEach($timers, id: \.id) { $timer in
                            GridTimerCell(gridTimer: $timer, itemSize: $itemSize, popoverTimer: $showTimer){
                                withAnimation {
                                    timers = timers.filter({ $0.id != timer.id })
                                }
                            } showInfo: {
                                showTimer = timer
                            }
                        }
                        if timers.count < gridLimit{
                            Button {
                                withAnimation {
                                    let timer = GridTimer(title: "Grid.Title.Timer".localize() + " \(timerCount)", time: Double.random(in: 0..<15), isActive: autoPlay)
                                    timers.append(timer)
                                    timerCount += 1
                                }
                            } label: {
                                ZStack{
                                    Color.blue.opacity(0.2)
                                    
                                    Image(systemName: "plus")
                                        .font(.largeTitle)
                                }.cornerRadius(itemSize.width / 12.8)
                            }
                            .frame(width: itemSize.width, height: itemSize.height)
                        }
                    }
                    .padding(.all, spacing)
//                }
            }
            .onAppear{
                DispatchQueue.main.async {
                    calculateGrid(size: geometry.size)
                }
            }
            .onChange(of: geometry.size.width) { _ in
                calculateGrid(size: geometry.size)
            }
            .sheet(item: $showTimer) { timer in
                NavigationView{
                    GridTimerDetailView(gridTimer: timer, showToolbar: true)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            if timers.count < gridLimit{
                                let timer = GridTimer(title: "Grid.Title.Timer".localize() + " \(timerCount)", time: Double.random(in: 0..<15), isActive: autoPlay)
                                timers.append(timer)
                                timerCount += 1
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(timers.count >= gridLimit)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func calculateGrid(size:CGSize){
        withAnimation {
            orientation = size.width > size.height ? .horizontal:.vertical
            var horizontalCount:CGFloat = 0
            var verticalCount:CGFloat = 0
            if UIDevice.current.userInterfaceIdiom == .phone{
                horizontalCount = (orientation == .horizontal) ? 4:2
                verticalCount   = (orientation == .horizontal) ? 2:4
            } else {
                horizontalCount = (orientation == .horizontal) ? 4:3
                verticalCount   = (orientation == .horizontal) ? 3:4
            }
            
            let spacing:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 12:8
            let width = (size.width - (spacing*2) - spacing * (horizontalCount - 1)) / horizontalCount
            let height = (size.height - (spacing*2) - spacing * (verticalCount - 1)) / verticalCount
            let size = width > height ? height:width
            itemSize = CGSize(width: size, height: size)
            gridItems = [GridItem](repeating: GridItem(.fixed(size), spacing: spacing, alignment: .center),
                                   count: Int(horizontalCount))
            self.spacing = spacing
        }
    }
}

struct GridTimerCell:View{
    
    @AppStorage("GridPlayVibration", store: userDefaults) var vibrate = true
    @AppStorage("GridPlayType", store: userDefaults) var soundType = 0
    @AppStorage("GridShape", store: userDefaults) var shape = 0
    
    @State var audioPlayer:AVAudioPlayer?
    
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @Binding var gridTimer:GridTimer
    @Binding var itemSize:CGSize
    @Binding var popoverTimer:GridTimer?
    
    @FocusState var isEditing
    @State var showTools = true
    @State var startTime = Date()
    @State var timeStamp = 0.0
    @State var isAdjusting = false
    
    var cellID = UUID().uuidString
    
    var deleteAction: () -> Void
    var showInfo: () -> Void
    
    var body: some View{
        ZStack{
            Button {
                if gridTimer.time < 0.01{
                    showInfo()
                } else {
                    gridTimer.isActive.toggle()
                    gridTimer.isActive == false ? stopTimer():startTimer()
                    timeStamp = gridTimer.time
                    showTools = !gridTimer.isActive
                    startTime = Date()
                }
            } label: {
                GridGaugeView(gridTimer: gridTimer,
                              shape: GridShape(rawValue: shape)!,
                              itemSize: itemSize)
                .onReceive(timer) { output in
                    withAnimation {
                        if gridTimer.isActive == true && gridTimer.time >= 0.01{
                            gridTimer.time -= 0.01
                            adjustTime()
                        } else if gridTimer.time < 0.01 {
                            completed()
                        }
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(isEditing)
            .frame(width: itemSize.width, height: itemSize.height, alignment: .center)

            VStack(alignment: .center){
                TextField("Title", text: $gridTimer.title)
                    .multilineTextAlignment(.center)
                    .focused($isEditing)
                    .aspectRatio(contentMode: .fit)
                Text("\(gridTimer.time, specifier: "%.2f")")
                    .multilineTextAlignment(.center)
            }
            .onChange(of: isEditing) { newValue in
                startTime = newValue ? startTime:Date()
                gridTimer.isActive = !newValue
            }

            if showTools{
                GridToolView(gridTimer: $gridTimer, deleteAction: deleteAction, showInfo: showInfo, stopTimer: {
                    stopTimer()
                })
                    .padding(.all, 8)
            }
        }
        .frame(width: itemSize.width, height: itemSize.height, alignment: .center)
        .onAppear {
            stopTimer()
        }
    }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [cellID])
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        
        let content = UNMutableNotificationContent()
        content.interruptionLevel = .timeSensitive
        content.title = gridTimer.title
        content.body = "Timer Completed"
        if soundType == 1{
            content.sound = UNNotificationSound.default
        } else if soundType >= 2{
            let soundNames = ["AUDIO_0004", "AUDIO_5242", "AUDIO_6413", "AUDIO_7063", "AUDIO_8166"]
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundNames[soundType - 2] + ".m4a"))
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: gridTimer.time, repeats: false)
        let request = UNNotificationRequest(identifier: cellID, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    func completed(){
        gridTimer.isActive = false
        showTools = true
        gridTimer.time = 0
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
    
    func adjustTime(){
        if isAdjusting == true { return }
        
        isAdjusting = true
        let currentTime = Date()
        let dif = currentTime.timeIntervalSince(startTime)
        let adjustTime = dif - (timeStamp - gridTimer.time)
        if adjustTime > 0{
            print("dif", String(format: "%.2f", adjustTime))
            if gridTimer.time - adjustTime < 0.01{
                completed()
            } else {
                gridTimer.time -= adjustTime
            }
        }
        isAdjusting = false
    }
}

struct GridGaugeView: View{
    
    @State private var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    var gridTimer:GridTimer
    var shape:GridShape
    var itemSize:CGSize
    
    var body: some View{
        ZStack{
            switch shape{
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
            
            switch shape {
            case .defaultShape:
                RoundedRectangle(cornerRadius: itemSize.height/25.6)
                    .trim(from: 0.0, to: gridTimer.time/gridTimer.maxTime)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(gridTimer.isActive ?  gridTimer.tint:Color(.secondarySystemFill))
                    .rotationEffect(Angle(degrees: 270.0))
                    .padding(.all, 4)
            case .circle:
                Circle()
                    .trim(from: 0.0, to: gridTimer.time/gridTimer.maxTime)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(gridTimer.isActive ?  gridTimer.tint:Color(.secondarySystemFill))
                    .rotationEffect(Angle(degrees: 270.0))
                    .padding(.all, 4)
            case .square:
                Rectangle()
                    .trim(from: 0.0, to: gridTimer.time/gridTimer.maxTime)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(gridTimer.isActive ?  gridTimer.tint:Color(.secondarySystemFill))
                    .rotationEffect(Angle(degrees: 270.0))
                    .padding(.all, 4)
            }
        }
        .onReceive(timer) { output in
            
        }
    }
}

struct GridTimerDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var gridTimer:GridTimer
    @State var selectedColor:Color
    var showToolbar:Bool
    
    var colors:[Color] = []
    
    var body: some View{
        List{
            Section{
                TextField("", text: $gridTimer.title)
                
                HStack{
                    Spacer()
                    TimerPicker(seconds: $gridTimer.maxTime)
                    Spacer()
                }
            }
            
            Section{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 34, maximum: 34), spacing: 16, alignment: .center)]) {
                    ForEach(colors, id: \.self) { color in
                        Button {
                            selectedColor = color
                            gridTimer.tint = color
                        } label: {
                            ZStack{
                                Circle()
                                    .foregroundColor(color)
                                    .frame(width: 25, height: 25)
                            }
                            .frame(width: 32, height: 32)
                            .overlay(
                                Circle()
                                    .stroke(lineWidth: selectedColor == color ? 2:0)
                                    .foregroundColor(color)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            Section{
                Toggle(isOn: $gridTimer.isTimeSensitive) {
                    Text("Grid.Setting.TimeSensitive")
                }.toggleStyle(SwitchToggleStyle(tint: .blue))
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                if showToolbar == true{
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Close")
                    }
                }
            }
        }
        .onChange(of: gridTimer.maxTime, perform: { newValue in
            gridTimer.time = newValue
        })
        .navigationBarTitleDisplayMode(.inline)
    }
    
    init(gridTimer: GridTimer, showToolbar:Bool){
        self._gridTimer = /*State<GridTimer>*/.init(initialValue: gridTimer)
        self.showToolbar = showToolbar
        
        if #available(iOS 15, *){
            colors = [.cyan, .blue, .purple, .indigo]
        } else {
            colors = [.blue]
        }
        _selectedColor = /*State<Color>*/.init(initialValue: gridTimer.tint)
    }
    
}

struct GridToolView: View{
    
    @Binding var gridTimer:GridTimer
    var deleteAction: () -> Void
    var showInfo: () -> Void
    var stopTimer: () -> Void
    
    var body: some View{
        VStack{
            HStack{
                Button {
                    stopTimer()
                    deleteAction()
                } label: {
                    ZStack{
                        Circle()
                            .foregroundColor(Color(.systemFill))
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12, alignment: .center)
                            .foregroundColor(.red)
                    }
                    .padding(.all, 4)
                }
                .frame(width: 36, height: 36, alignment: .center)
                
                Spacer()

                if UIDevice.current.userInterfaceIdiom == .phone{
                    NavigationLink {
                        NavigationView{
                            GridTimerDetailView(gridTimer: gridTimer, showToolbar: false)
                        }
                    } label: {
                        ZStack{
                            Circle()
                                .foregroundColor(Color(.systemFill))
                            Image(systemName: "info")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(.blue)
                        }
                        .padding(.all, 4)
                    }.frame(width: 36, height: 36, alignment: .center)
                } else {
                    Button(action: { showInfo() }) {
                        ZStack{
                            Circle()
                                .foregroundColor(Color(.systemFill))
                            Image(systemName: "info")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundColor(.blue)
                        }
                        .padding(.all, 4)
                    }
                    .frame(width: 36, height: 36, alignment: .center)
                }
            }

            Spacer()
        }
    }
}

struct GridTimerView_Previews: PreviewProvider {
    static var previews: some View {
        GridTimerView()
    }
}
