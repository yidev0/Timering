//
//  CustomPersistentContainer.swift
//  Timering
//
//  Created by Yuto on 2022/08/09.
//

import Foundation
import CoreData

public class CustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.yiwa.Timering")
        storeURL = storeURL?.appendingPathComponent("Timering")
        return storeURL!
    }

}
