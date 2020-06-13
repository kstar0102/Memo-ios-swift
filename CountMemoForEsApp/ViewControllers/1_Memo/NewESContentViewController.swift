//
//  NewESContentViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/04/07.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class NewESContentViewController: UIViewController
, UITextViewDelegate, UITextFieldDelegate
{

    internal var memo:Memo? = nil

    @IBOutlet weak var countLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var companyLb: UILabel!
    @IBOutlet weak var endDateLb: UILabel!
    
    @IBOutlet weak var memoContentTxt: UITextView!
    
    var currentMemoNum = 0
    var preContentTxt:String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        Common.setBorderColor(view: self.memoContentTxt)
        self.memoContentTxt.delegate = self

        if let memo:Memo = memo {
            titleLb.text = memo.title
            companyLb.text = memo.company
            memoContentTxt.text = memo.memoText
            endDateLb.text = memo.memoDate
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
            formatter.dateFormat = "yyyy年MM月dd日HH時"
        }
        countLb.text = String(memoContentTxt.text.count)
        print(memoContentTxt)

        addDoneButtonOnKeyboard()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.memoContentTxt.inputAccessoryView = doneToolbar
    }


    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.memoContentTxt.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.memoContentTxt.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.memoContentTxt.contentInset = contentInset
    }
    
    @objc func doneButtonAction(){
        self.memoContentTxt.resignFirstResponder()
    }

    func checkEmptyFeild() -> Bool {
        
        if self.memoContentTxt.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "ES説明文"+Config.INPUT_ERR_MSG)
            return false
        }else {
        }
        
        return true
    }
    
    func saveMemoData() {
        if self.checkEmptyFeild() {
            //alertの設定
            let alert: UIAlertController = UIAlertController(title: "メモの登録", message: "この内容で保存しますか？", preferredStyle:  UIAlertController.Style.alert)

            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            // OKボタン押下時のイベント
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in

                        LocalNotificationManager.removeNotification(id: self.memo!.company!+self.memo!.title!)
                        // 編集の場合は詳細画面から渡されたself.memoを変更、
                        // 新規の場合は新しいMemoオブジェクトを作り、現在の日時を入れる_
                        let memo: Memo = {
                            if let memo = self.memo {
                                memo.createdAt = Date()
                                return memo
                            } else {
                                let memo = Memo(context: DatabaseManager.persistentContainer.viewContext)
                                memo.createdAt = Date()
                                return memo
                            }
                        }()

                        memo.title = self.titleLb.text
                        memo.company = self.companyLb.text
                        memo.memoText = self.memoContentTxt.text
                        memo.memoDate = self.endDateLb.text
                        memo.memoNum = String(self.currentMemoNum)

                        // 上で作成したデータをデータベースに保存 the data into the database.
                        let timeInterval = memo.alertDate?.timeIntervalSince(Common.calcDate(baseDate: Date()))
                        if timeInterval != nil {
                            if timeInterval! > 0{
                                print(timeInterval)
                                DatabaseManager.saveContext()
                                LocalNotificationManager.addNotificaion(title: memo.company!, id: memo.company!+memo.title!, time: timeInterval!)
                            }
                        }
                        //入力値をクリアにする
                        self.clearData()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                    alert.dismiss(animated: true, completion: nil)

                    // UIAlertControllerにActionを追加
                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    
                    // Alertを表示
                    present(alert, animated: true, completion: nil)
        }
    }

    // 入力値をクリア
    func clearData()  {
        memoContentTxt.text = ""
    }

    
    //入力ごとに文字数をカウントする
    func textViewDidChange(_ textView: UITextView) {
        let str = memoContentTxt.text
        let commentNum = memoContentTxt.text.count
        //空白と改行を抽出して取り除く
        let newStr = String(str!.unicodeScalars
            .filter(CharacterSet.whitespacesAndNewlines.contains)
            .map(Character.init))
        let numLabel = commentNum - newStr.count
        if numLabel > 400 {
            self.memoContentTxt.text = preContentTxt
            return
        }
        currentMemoNum = numLabel
        preContentTxt = memoContentTxt.text
        countLb.text = String(commentNum) + " 文字"
    }

    
    @IBAction func editBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        saveMemoData()
    }
}
