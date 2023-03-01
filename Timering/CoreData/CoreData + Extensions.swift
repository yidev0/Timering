//
//  CoreData + Extensions.swift
//  Timering
//
//  Created by Yuto on 2022/08/13.
//

import Foundation
import CoreData
import SwiftUI









extension NSObject {
    func toColor() -> Color {
        if let color = self as? UIColor {
            return Color(uiColor: color)
        }
        return .blue
    }
}
