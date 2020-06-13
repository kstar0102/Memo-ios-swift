//
//  MemoViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/21.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class MemoViewController: UIViewController
, UITableViewDelegate
, UITableViewDataSource
, UITextViewDelegate
, WWCalendarTimeSelectorProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var tableViewCell: UITableViewCell!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var actionBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var countLb: UILabel!
    @IBOutlet weak var companyLe: ScaleTextField!
    @IBOutlet weak var memoTitleLe: ScaleTextField!
    @IBOutlet weak var memoDateLe: ScaleTextField!
    @IBOutlet weak var memoContentTxt: ScaledTextView!
    
    internal var memo:Memo? = nil
    internal var editType:String = "new"
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []

    var editable:Bool = true
    var preContentTxt:String = ""

    //UIDatePickerを定義するための変数
    var datePicker: UIDatePicker = UIDatePicker()
    //resultDateで１日前を日付計算
    var resultDate:Date?
    
    var currentMemoNum = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.alwaysBounceVertical = false
        
        
        self.actionBtn.layer.cornerRadius = 5
        Common.setBorderColor(view: self.memoContentTxt)
        
//        // ピッカー設定
//        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
//        datePicker.timeZone = NSTimeZone.local
//        datePicker.locale = Locale(identifier: "ja")
//        memoDateLe.inputView = datePicker
        
        self.memoContentTxt.delegate = self

//        // 決定バーの生成
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
//        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtn))
//        toolbar.setItems([spacelItem, doneItem], animated: true)
//
//        // インプットビュー設定(紐づいているUITextfieldへ代入)
//        memoDateLe.inputView = datePicker
//        memoDateLe.inputAccessoryView = toolbar

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        if self.editType == "new" {
            self.actionBtn.isHidden = true
            self.actionBtnHeight.constant = 0
            self.editable = true
            self.memoTitleLe.becomeFirstResponder()
        }else {
            self.actionBtn.isHidden = false
            self.actionBtnHeight.constant = 30
            self.editable = false
            
            if let memo:Memo = memo {
                memoTitleLe.text = memo.title
                companyLe.text = memo.company
                memoContentTxt.text = memo.memoText
                memoDateLe.text = memo.memoDate
                
                let formatter = DateFormatter()
                formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
                formatter.dateFormat = "yyyy年MM月dd日HH時"
                singleDate = formatter.date(from: memo.memoDate!)!
            }
        }
        countLb.text = String(memoContentTxt.text.count)
        setEditingFeilds()
        
        addDoneButtonOnKeyboard()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setEditingFeilds() {
        self.companyLe.isEnabled = self.editable
        self.memoTitleLe.isEnabled = self.editable
        self.memoDateLe.isEnabled = self.editable
        self.memoContentTxt.isEditable = self.editable

        if self.editable {
            self.actionBtn.setTitle("完了", for: .normal)
        }else {
            self.actionBtn.setTitle("編集", for: .normal)
        }
    }

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.companyLe.inputAccessoryView = doneToolbar
        self.memoTitleLe.inputAccessoryView = doneToolbar
        self.memoContentTxt.inputAccessoryView = doneToolbar
    }

    /*
     ピッカーのdoneボタン
    */

        // UIDatePickerのDoneを押したら発火
        @objc func doneBtn() {
            self.memoDateLe.resignFirstResponder()

            // 日付のフォーマット
            let formatter = DateFormatter()
            //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できる
            formatter.dateFormat = "yyyy年MM月dd日HH時"
            //datePickerで指定した日付が表示される
            memoDateLe.text = "\(formatter.string(from: datePicker.date))"
            let pickerTime = datePicker.date

            print(pickerTime)
            //前日,日本時間を設定
            resultDate = Common.calcDate(baseDate: pickerTime)
        }


    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.tableView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInset
    }
    
    @objc func doneButtonAction(){
        self.companyLe.resignFirstResponder()
        self.memoTitleLe.resignFirstResponder()
        self.memoContentTxt.resignFirstResponder()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCell
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return SCALE(value: 750)
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
        self.countLb.text = String(commentNum) + "文字"
    }
    
    func showCalendarSelecter() {
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates)
        selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)

        present(selector, animated: true, completion: nil)
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print("Selected \n\(date)\n---")
        singleDate = date
        // 日付のフォーマット
        let formatter = DateFormatter()
        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できる
        formatter.dateFormat = "yyyy年MM月dd日HH時"
        //datePickerで指定した日付が表示される
        memoDateLe.text = "\(formatter.string(from: date))"
        let pickerTime = date

        print(pickerTime)
        //前日,日本時間を設定
        resultDate = Common.calcDate(baseDate: pickerTime)
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        print("Selected Multiple Dates \n\(dates)\n---")
        if let date = dates.first {
            singleDate = date
        }
        else {
        }
        multipleDates = dates
    }

    func checkEmptyFeild() -> Bool {
        
        if self.companyLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "企業名"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.memoTitleLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "ESタイトル"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.memoDateLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "ES締め切り日時"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.memoContentTxt.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "ES説明文"+Config.INPUT_ERR_MSG)
            return false
        }else {
        }
        
        return true
    }

    
    @IBAction func actionBtnClicked(_ sender: Any) {
        if self.editable {
            saveMemoData()
        }else {
            self.editable = !self.editable
            self.setEditingFeilds()
            self.memoTitleLe.becomeFirstResponder()
        }
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

                        if self.editType != "new" {
                            LocalNotificationManager.removeNotification(id: self.memo!.company!+self.memo!.title!)
                        }
                        // 編集の場合は詳細画面から渡されたself.memoを変更、
                        // 新規の場合は新しいMemoオブジェクトを作り、現在の日時を入れる_
                        let memo: Memo = {
                            if let memo = self.memo {
                                memo.createdAt = Date()
                                memo.alertDate = self.resultDate
                                return memo
                            } else {
                                let memo = Memo(context: DatabaseManager.persistentContainer.viewContext)
                                memo.createdAt = Date()
                                memo.alertDate = self.resultDate
                                return memo
                            }
                        }()

                        memo.title = self.memoTitleLe.text
                        memo.company = self.companyLe.text
                        memo.memoText = self.memoContentTxt.text
                        memo.memoDate = self.memoDateLe.text
                        memo.alertDate = self.resultDate
                        memo.memoNum = String(self.currentMemoNum)
                        let timeInterval = memo.alertDate?.timeIntervalSince(Common.calcDate(baseDate: Date()))
                        if timeInterval != nil {
                            if timeInterval! > 0{
                                DatabaseManager.saveContext()
                                LocalNotificationManager.addNotificaion(title: memo.company!, id: memo.company!+memo.title!, time: timeInterval!)
                            }
                        }
                        //入力値をクリアにする
                        self.clearData()
                        self.navigationController?.popViewController(animated: true)
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
        companyLe.text = ""
        memoTitleLe.text = ""
        memoDateLe.text = ""
        memoContentTxt.text = ""
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func timeBtnClicked(_ sender: Any) {
        if editable {
            showCalendarSelecter()
        }
    }

}
