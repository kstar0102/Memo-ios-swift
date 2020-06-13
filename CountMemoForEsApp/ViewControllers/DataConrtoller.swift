//
//  DataConrtoller.swift
//  CountMemoForEsApp
//
//  Created by 石川陽子 on 2019/02/21.
//  Copyright © 2019年 Yoko Ishikawa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController: NSObject {
    var persistentContainer: NSPersistentContainer!
    
    init(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }
    
    // 以下もっと追加していくよー
    
}

