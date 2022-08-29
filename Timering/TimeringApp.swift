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

extension Date {
    func isToday() -> Bool{
        let date = Date()
        let currentCalendar = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let selfCalendar = Calendar.current.dateComponents([.year, .month, .day], from: self)
        
        return currentCalendar.year == selfCalendar.year &&
               currentCalendar.month == selfCalendar.month &&
               currentCalendar.day == selfCalendar.day
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

//https://stackoverflow.com/a/73185092/9239373
extension Color: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else{
            self = .black
            return
        }
        
        do{
            let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor ?? .black
            self = Color(color)
        } catch {
            self = .black
        }
    }

    public var rawValue: String {
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
        } catch {
            return ""
        }
    }
}
