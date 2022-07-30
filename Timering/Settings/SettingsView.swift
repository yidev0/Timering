//
//  SettingsView.swift
//  Timering
//
//  Created by Yuto on 2022/04/01.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var timerType:TimerType
    
    @State var showWelcome = false
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    switch timerType {
                    case .ring:
                        RingSettingsView()
                    case .grid:
                        GridSettingsView()
                    }
                } header: {
                    Text(timerType == .ring ? "Ring":"Grid")
                }
                
                Section{
                    NavigationLink {
                        List{
                            switch timerType {
                            case .ring:
                                GridSettingsView()
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                            case .grid:
                                RingSettingsView()
                                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                            }
                        }.navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Label(timerType != .ring ? "Settings.Title.Ring":"Settings.Title.Grid",
                              systemImage: timerType != .ring ? "circle.circle":"square.grid.2x2")
                    }
                    
                    Link(destination: URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!)!) {
                        Label(title: { Text("Welcome.Title.OpenSettings").foregroundColor(.primary) },
                              icon: { Image(systemName: "bell.badge") })
                    }
                } header: {
//                    Text(timerType != .ring ? "Settings.Title.Ring":"Settings.Title.Grid")
                }
                
                Section{
                    NavigationLink {
                        IconsView()
                    } label: {
                        Label("Settings.Title.Icons", systemImage: "app")
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        Label("Settings.Title.UnlockFeatures", systemImage: "lock")
                    }
                }
                
                Section{
                    Link(destination: URL(string: "FeedbackURL".localize())!) {
                        Label(
                            title: { Text("Settings.Title.Feedback").foregroundColor(.primary) },
                            icon: { Image(systemName: "safari").foregroundColor(.blue) })
                    }
                    
                    Link(destination: URL(string: "https://twitter.com/BookmarkApp_")!) {
                        Label(
                            title: { Text("Twitter(@BookmarkApp_)").foregroundColor(.primary) },
                            icon: { Image(systemName: "link").foregroundColor(Color(.systemTeal)) })
                    }
                    
                    if checkOLEDDisplay(){
                        Link(destination: URL(string: "https://support.apple.com/HT208191")!) {
                            Label(
                                title: { Text("Settings.AboutDisplay").foregroundColor(.primary) },
                                icon: { Image(systemName: "iphone").foregroundColor(.primary) })
                        }
                    }
                    
                    #if DEBUG
                    Button(action: { showWelcome = true }) {
                        Text("Settings.DEBUG.Title.ShowWelcome")
                    }
                    #endif
                }
            }
            .listStyle(.insetGrouped)
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .navigationTitle("Settings.Title")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Navigation.Done")
                    }
                }
            }
            .sheet(isPresented: $showWelcome) {
                if #available(iOS 15.0, *) {
                    WelcomeView()
                }
            }
        }
    }
    
    func checkOLEDDisplay() -> Bool{
        if UIDevice.current.userInterfaceIdiom == .pad { return false }
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        var deviceName = ""
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            deviceName = identifier
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        if let num = Int(deviceName.replacingOccurrences(of: "iPhone", with: "").replacingOccurrences(of: ",", with: "")){
            if num >= 10{
                let exceptionNames = ["iPhone10,1", "iPhone10,4","iPhone10,2", "iPhone10,5","iPhone11,8","iPhone12,1","iPhone12,8","iPhone14,6"]
                if exceptionNames.contains(identifier) != true{
                    return true
                }
            }
        }
        return false
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    @State var timerType:TimerType
    
    static var previews: some View {
        SettingsView(timerType: .constant(.ring))
    }
}
