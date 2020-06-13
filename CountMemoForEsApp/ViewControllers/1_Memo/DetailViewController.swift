//
//  DetailViewController.swift
//  CountMemoForEsApp
//
//  Created by 石川陽子 on 2019/02/09.
//  Copyright © 2019年 Yoko Ishikawa. All rights reserved.
//

import UIKit
import CoreData
// 詳細表示画面
class DetailViewController: UIViewController {
    

    @IBOutlet var titleData: UILabel!
    @IBOutlet var companyData: UILabel!
    @IBOutlet var dateData: UILabel!
    @IBOutlet var numdata: UILabel!
    @IBOutlet var textData: UITextView!
    
    var detailData:Memo?
//    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var titleStr: String?
    var company: String?
    var memoText: String = ""
    var memoNum: String?
    var memoDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //入力不可
        textData.isEditable = false
        
        
        if let detailData:Memo = detailData {
            titleData.text = detailData.title
            companyData.text = detailData.company
            textData.text = detailData.memoText
            numdata.text = detailData.memoNum
            dateData.text = detailData.memoDate
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "toEdit", sender: nil)
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "toEdit":
            // segueから遷移先のNavigationControllerを取得(画面遷移)
            let nc = segue.destination as! UINavigationController
            // NavigationControllerの一番目のViewControllerが次の画面
            let vc = nc.topViewController as! ViewController
            // contextをAddTaskViewController.swiftのcontextへ渡す
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            vc.context = context
            
            vc.memo = self.detailData

        default:
            fatalError("Unknow segue: \(identifier)")
        }
    }
    
}
