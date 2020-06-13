//
//  MemoTableViewController.swift
//  CountMemoForEsApp
//
//

import UIKit
import CoreData
import UserNotifications

class MemoTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    //配列作成(coreData) for tableView
    var memoData:[Memo] = []
    
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 編集ボタンを左上に配置
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.tintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        //編集中のセル選択を許可
        tableView.allowsSelectionDuringEditing = true
        self.tableView.rowHeight = 60
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        //配列が追加した後もういちどデータをリロードさせる
        tableView.reloadData()
    }
    
    func getData() {
        // データ保存時と同様にcontextを定義
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        do {
//            // CoreDataからデータをfetchしてtasksに格納
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
//            fetchRequest.returnsObjectsAsFaults = false
////            並び順を作成順に指定
//            fetchRequest.sortDescriptors = [
//                NSSortDescriptor(key: "createdAt", ascending: true)
//            ]
//            memoData = try context.fetch(fetchRequest) as! [Memo]
//
//            for i in 0..<memoData.count{
//                // Notification のインスタンス作成
//                let content = UNMutableNotificationContent()
//                
//                // タイトル、本文の設定
//                let titleTexr = memoData[i].company!
//                content.title = "\(String(describing: titleTexr))"
//                content.body = "エントリーシートの締め切りが迫っています。"
//             
                let date = memoData[i].alertDate

                if let date = date{
                    let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    //トリガー設定
                    let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)
                    //リクエストの設定
                    let request = UNNotificationRequest.init(identifier: "ID_SpecificTime", content: content, trigger: trigger)
                    //通知
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
//            }
//            
//            return
//        } catch {
//            print("Fetching Failed.")
//        }
        
    }
    //セクションの数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //何行か
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoData.count
    }
    //セルの作成　rowは何行目か
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell

        cell.titleLabel.text = self.memoData[indexPath.row].title
        cell.numLabel.text = self.memoData[indexPath.row].memoNum
        cell.companyLabel.text = self.memoData[indexPath.row].company
        
        return cell
    }
    //セルの削除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert: UIAlertController = UIAlertController(title: "注意", message: "削除してもよろしいですか？\n（１度削除したデータは復元できません。）", preferredStyle:  UIAlertController.Style.actionSheet)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//         if editingStyle == .delete {
//
//            let deletedMemoData = memoData[indexPath.row]
//
//            context.delete(deletedMemoData)
//            memoData.remove(at: indexPath.row)
//
//            // 削除したあとのデータを保存する
//            (UIApplication.shared.delegate as! AppDelegate).saveContext()
//
//            // 削除後の全データをfetchする
//            getData()
//        }
        // taskTableViewを再読み込みする
        tableView.reloadData()
    }
    
 //セルを選択した時に実行
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
//編集
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }

//画面遷移で値を引き渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "showDetail":
            //渡したい値を設定する
            let indexPath = tableView.indexPathForSelectedRow
            // segueから遷移先のNavigationControllerを取得(画面遷移)
            let nc = segue.destination as! UINavigationController
            // NavigationControllerの一番目のViewControllerが次の画面
            let vc = nc.topViewController as! DetailViewController
            // contextをAddTaskViewController.swiftのcontextへ渡す
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            vc.context = context
 
            //indexPathがnilでないことを確認し、選択した行のデータを引きわたす
            
            if let indexPath = indexPath{
                vc.detailData = self.memoData[indexPath.row]
            }


        default:
            fatalError("Unknow segue: \(identifier)")
        }
     }
}

