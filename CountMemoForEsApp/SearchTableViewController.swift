//
//  SearchTableViewController.swift
//  CountMemoForEsApp
//
//  Created by 石川陽子 on 2019/02/10.
//  Copyright © 2019年 Yoko Ishikawa. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet var searchBar: UITableView!
    var memoData:[Memo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "company")
  
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return cell
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String) {
//        if(searchText != ""){
//            var predicate: NSPredicate = NSPredicate()
//            predicate = NSPredicate(format: "company contains[c] '\(searchText)'" )
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "company")
//            fetchRequest.predicate = predicate
//            do{
//                memoData = try context.fetch(fetchRequest) as! [Memo]
//            } catch {
//                print("Could not get search data.")
//            }
//        }
        tableView.reloadData()
    }

}
