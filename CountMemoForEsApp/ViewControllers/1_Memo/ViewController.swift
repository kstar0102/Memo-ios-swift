//
//  ViewController.swift
//  CountMemoForEsApp
//
//  Created by 石川陽子 on 2019/01/27.
//  Copyright © 2019年 Yoko Ishikawa. All rights reserved.
//

import UIKit
import CoreData

//データを保存する画面
class ViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {
    //それぞれUI部品を定義
    @IBOutlet var titleField: UITextField!
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var memoNumLabel: UILabel!
    @IBOutlet var companyField: UITextField!
    @IBOutlet var dateField: UITextField!
    
    //coreData（エンティティがMemo）
    var memo:Memo?
    
    //UIDatePickerを定義するための変数
    var datePicker: UIDatePicker = UIDatePicker()
    //resultDateで１日前を日付計算
    var resultDate:Date?
    //MemoTableViewConrtollerから引き渡されたcontext
//    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

/*
 画面が呼ばれる前
*/
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    //テキストフィールド以外のところをタップするとキーボードが閉じる
    @IBAction func tapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    
/*
 画面が呼ばれた時
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        memoTextView.delegate =  self
        companyField.delegate = self
        dateField.delegate = self
        
        if let memo = self.memo{
            //メモの値を表示。
            editedMemo(memo)
        }
        
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale(identifier: "ja")
        dateField.inputView = datePicker
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.doneBtn))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定(紐づいているUITextfieldへ代入)
        dateField.inputView = datePicker
        dateField.inputAccessoryView = toolbar
        //キーボードを閉じる
        view.endEditing(true)
    }
/*
 ピッカーのdoneボタン
*/

    // UIDatePickerのDoneを押したら発火
    @objc func doneBtn() {
        dateField.endEditing(true)
        
        // 日付のフォーマット
        let formatter = DateFormatter()
        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できる
        formatter.dateFormat = "yyyy年MM月dd日H時"
        //datePickerで指定した日付が表示される
        dateField.text = "\(formatter.string(from: datePicker.date))"
        let pickerTime = datePicker.date

        //前日,日本時間を設定
        resultDate = calcDate(day: -1 ,hour: 0 ,baseDate: pickerTime)
    }

    //入力ごとに文字数をカウントする
    func textViewDidChange(_ textView: UITextView) {
        let str = memoTextView.text
        let commentNum = memoTextView.text.count
        //空白と改行を抽出して取り除く
        let newStr = String(str!.unicodeScalars
            .filter(CharacterSet.whitespacesAndNewlines.contains)
            .map(Character.init))
        let numLabel = newStr.count
        memoNumLabel.text = String(commentNum - numLabel)
        
    }
    
    func editedMemo(_ memo:Memo){
        //編集用に表示
        titleField.text = memo.title
        companyField.text = memo.company
        memoTextView.text = memo.memoText
        memoNumLabel.text = memo.memoNum
        dateField.text = memo.memoDate
        
    }
    
    @IBAction func saveMemo(_ sender: Any) {
        //alertの設定
        let alert: UIAlertController = UIAlertController(title: "メモの登録", message: "この内容で保存しますか？", preferredStyle:  UIAlertController.Style.alert)

        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        

        // OKボタン押下時のイベント
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in

            // 編集の場合は詳細画面から渡されたself.memoを変更、
            // 新規の場合は新しいMemoオブジェクトを作り、現在の日時を入れる_
//            let memo: Memo = {
//                if let memo = self.memo {
//                    memo.createdAt = Date()
//                    memo.alertDate = self.resultDate
//                    return memo
//                } else {
////                    let memo = Memo(context: self.context)
////                    memo.createdAt = Date()
////                    memo.alertDate = self.resultDate
////                    return memo
//                }
//            }()
//
//            memo.title = self.titleField.text
//            memo.company = self.companyField.text
//            memo.memoText = self.memoTextView.text
//            memo.memoNum = self.memoNumLabel.text
//            memo.memoDate = self.dateField.text
//            memo.alertDate = self.resultDate
 
            // 上で作成したデータをデータベースに保存
//            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//            self.dismiss(animated: true, completion: nil)

            //入力値をクリアにする
            self.clearData()
//            self.performSegue(withIdentifier: "returnHome", sender: self)
        }
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        alert.dismiss(animated: true, completion: nil)

        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        // Alertを表示
        present(alert, animated: true, completion: nil)
        
    }
    // 入力値をクリア
    func clearData()  {
        titleField.text = ""
        companyField.text = ""
        memoTextView.text = ""
        memoNumLabel.text = "0"
        dateField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを隠す
        textField.resignFirstResponder()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    //データを保存
    func saveContext () {
        
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//                print(context)
//
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
    }
    
    func calcDate(day:Int ,hour:Int ,baseDate:Date ) -> Date {
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var components = DateComponents()
        
        components.setValue(day,for: Calendar.Component.day)
        components.setValue(hour,for: Calendar.Component.hour)
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)

        return calendar.date(byAdding: components, to: baseDate)!
    }
}

