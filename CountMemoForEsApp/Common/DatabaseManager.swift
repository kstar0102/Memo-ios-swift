//
//  DatabaseManager.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/21.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager: NSObject {
    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: "CountMemoForEsApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func getSearchDatas(keyword: String) -> [Memo] {
        var searchData:[Memo] = []

        let context = persistentContainer.viewContext
        //%@はstring型を表す
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
        if(keyword != ""){
            //複数条件かつ部分一致でじ検索
            let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or
                , subpredicates: [
                    NSPredicate(format: "%K CONTAINS %@","company", "\(keyword)"),
                    NSPredicate(format: "%K CONTAINS %@", "title","\(keyword)"),
                    ])
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "createdAt", ascending: true)
            ]

            let fetchData = try! context.fetch(fetchRequest)

            if(!fetchData.isEmpty){
                for i in 0..<fetchData.count{
                    searchData.append(fetchData[i] as! Memo)
                }
                do{
                    try context.save()
                }catch{
                    print(error)
                }
            }
        }else {
            do {
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(key: "createdAt", ascending: true)
                ]
                
                searchData = try context.fetch(fetchRequest) as! [Memo]
            }catch {
                print("Fetching Failed.")
            }
        }

        return searchData;
    }
    
    static func getTodoDatas(completed: Bool) -> [Todo] {
        var searchData:[Todo] = []
        let context = persistentContainer.viewContext
        //%@はstring型を表す
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        //複数条件かつ部分一致でじ検索
        let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or
            , subpredicates: [
                NSPredicate(format: "completedFlag == %@", NSNumber(value: completed))
                ])
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]

        let fetchData = try! context.fetch(fetchRequest)

        if(!fetchData.isEmpty){
            for i in 0..<fetchData.count{
                searchData.append(fetchData[i] as! Todo)
            }
            do{
                try context.save()
            }catch{
                print(error)
            }
        }

        return searchData
    }
    
    static func getUseroDatas() -> [UserProfile] {
        var searchData:[UserProfile] = []
        let context = persistentContainer.viewContext
        //%@はstring型を表す
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserProfile")
       
        let fetchData = try! context.fetch(fetchRequest)

        if(!fetchData.isEmpty){
            for i in 0..<fetchData.count{
                searchData.append(fetchData[i] as! UserProfile)
            }
            do{
                try context.save()
            }catch{
                print(error)
            }
        }

        return searchData
    }
    
    
}
