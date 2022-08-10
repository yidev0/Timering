//
//  GridSettingsView.swift
//  Timering
//
//  Created by Yuto on 2022/04/02.
//

import SwiftUI
import AVFoundation

struct GridSettingsView: View {
    
    @AppStorage("GridAutoPlay", store: userDefaults) var autoPlay = false
    @AppStorage("GridPlayVibration", store: userDefaults) var vibrate = true
    @AppStorage("GridPlayType", store: userDefaults) var soundType = 0
    @AppStorage("GridShape", store: userDefaults) var shape = 0
    let colors:[UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemBlue, .systemTeal, .systemGreen, .systemPurple, .systemIndigo, .systemGray, .label]
    
    var body: some View {
        Toggle(isOn: $autoPlay) {
            Label("Settings.Grid.Autoplay", systemImage: "play")
        }
        
        NavigationLink {
            GridSoundSettingsView()
        } label: {
            HStack{
                Label("Settings.Grid.SoundType", systemImage: "speaker.\(soundType == 0 ? "slash":"wave.2")")
                Spacer()
                Text("\(soundType)")
                    .foregroundColor(.secondary)
            }
        }

        Toggle(isOn: $vibrate) {
            Label("Settings.Grid.PlayVibration", systemImage: "waveform")
        }
        
        HStack{
            Picker(selection: $shape) {
                Label("Settings.Grid.Shape.Default", systemImage: "app.fill")
                    .tag(0)
                Label("Settings.Grid.Shape.Circle", systemImage: "circle.fill")
                    .tag(1)
                Label("Settings.Grid.Shape.Square", systemImage: "squareshape.fill")
                    .tag(2)
            } label: {
                Label("Settings.Grid.ShapeType", systemImage: "square.on.circle")
            }
        }
        
    }
}

struct GridSoundSettingsView: View{
    
    @AppStorage("GridPlayType", store: userDefaults) var soundType = 0
    let soundNames = ["AUDIO_0004", "AUDIO_5242", "AUDIO_6413", "AUDIO_7063", "AUDIO_8166"]
    @State var audioPlayer:AVAudioPlayer?
    
    var body: some View{
        List{
            Button {
                soundType = 0
            } label: {
                HStack{
                    Label("Settings.Grid.Sound.Off", systemImage: "speaker.slash")
                        .foregroundColor(.red)
                    Spacer()
                    if soundType == 0{
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            Button {
                AudioServicesPlayAlertSound(SystemSoundID(1322))
                soundType = 1
            } label: {
                HStack{
                    Label("Settings.Grid.Sound.System", systemImage: "speaker.wave.2")
                    Spacer()
                    if soundType == 1{
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            ForEach(0..<5) { i in
                Button {
                    if let soundFileURL = Bundle.main.path(forResource: "\(soundNames[i]).m4a", ofType: nil){
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
                    soundType = i + 2
                } label: {
                    HStack{
                        Label("Settings.Grid.Sound.\(i+1)", systemImage: "speaker.wave.2")
                        Spacer()
                        if soundType == i + 2{
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GridSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GridSettingsView()
    }
}
