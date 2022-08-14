//
//  TimeringApp.swift
//  Timering
//
//  Created by Yuto on 2022/03/31.
//

import SwiftUI
import UserNotifications

@main
struct TimeringApp: App {
    
    @State var showWelcome = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .sheet(isPresented: $showWelcome) {
                    //dimiss
                } content: {
                        WelcomeView()
                }
                .onAppear {
                    if userDefaults?.bool(forKey: "hasShownWelcomeBeta") != true{
                        showWelcome = true
                    }
                }

        }
    }
}

let userDefaults = UserDefaults(suiteName: "group.yiwa.Timering")

extension Color {
    /// Return a random color
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
extension UIColor {
    /// Return a random color
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1
        )
    }
}

extension String{
    func localize() -> String{
        return NSLocalizedString(self, comment: self)
    }
}

enum DeviceOrientation{
    case vertical, horizontal
}
