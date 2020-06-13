//
//  AddTodoViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/23.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit


class AddTodoViewController: UIViewController
, UITableViewDelegate
, UITableViewDataSource
, UITextViewDelegate
, WWCalendarTimeSelectorProtocol{
    
    
    internal var taskType: String = "todo"
    internal var editType:String = "new"
    internal var todo:Todo? = nil

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewCell: UITableViewCell!
    
    @IBOutlet weak var editbtn: UIButton!
    @IBOutlet weak var taskNameLe: ScaleTextField!
    
    @IBOutlet weak var taskDetailTxt: ScaledTextView!
    @IBOutlet weak var timeLe: ScaleTextField!
    
    @IBOutlet weak var colorBtn1: UIButton!
    @IBOutlet weak var colorBtn2: UIButton!
    @IBOutlet weak var colorBtn3: UIButton!
    @IBOutlet weak var colorBtn4: UIButton!
    @IBOutlet weak var colorBtn5: UIButton!
    @IBOutlet weak var coloBtn6: UIButton!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    //UIDatePickerを定義するための変数
    var datePicker: UIDatePicker = UIDatePicker()
    var editable:Bool = true
    //resultDateで１日前を日付計算
    var resultDate:Date?
    var selectedColorIndex: Int = 0
    var preContentTxt:String = ""
    var nowdate:Date = Date(timeIntervalSinceReferenceDate: -123456789.0)
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        Common.setBorderColor(view: self.taskDetailTxt)
        self.colorBtn1.layer.cornerRadius = 15
        self.colorBtn2.layer.cornerRadius = 15
        self.colorBtn3.layer.cornerRadius = 15
        self.colorBtn4.layer.cornerRadius = 15
        self.colorBtn5.layer.cornerRadius = 15
        self.coloBtn6.layer.cornerRadius = 15

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.alwaysBounceVertical = false
        
        setUI(colorBtn1)
        self.taskDetailTxt.delegate = self
        self.taskNameLe.becomeFirstResponder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        if self.editType == "new"{
            let titleStr = "タイトル"
            let placeHolder = NSAttributedString(string: titleStr, attributes:  [NSAttributedString.Key.foregroundColor: UIColor.white])
                taskNameLe.attributedPlaceholder = placeHolder
            self.editable = true
        }else{
            taskNameLe.text = todo?.name
            taskDetailTxt.text = todo?.desc
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.dateFormat = "yyyy年MM月dd日HH時"
            let myStringafd = formatter.string(from: (todo?.alertTime!)!)
            timeLe.text = myStringafd
            nowdate = todo!.alertTime!
            self.editable = false
            //Config.TodoColorSelect(todo?.bgColor)
            setUI(colorBtn4)
        }
        setEditingFeilds()
        addDoneButtonOnKeyboard()
    }
    
    func setEditingFeilds() {
        self.taskNameLe.isEnabled = self.editable
        self.timeLe.isEnabled = self.editable
        self.taskDetailTxt.isEditable = self.editable
        if self.editable {
            self.editbtn.setTitle("保存", for: .normal)
        }else {
            self.editbtn.setTitle("編集", for: .normal)
        }
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

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.taskNameLe.inputAccessoryView = doneToolbar
        self.taskDetailTxt.inputAccessoryView = doneToolbar
    }

    /*
     ピッカーのdoneボタン
    */

        // UIDatePickerのDoneを押したら発火
        @objc func doneBtn() {
            self.timeLe.resignFirstResponder()

            // 日付のフォーマット
            let formatter = DateFormatter()
            //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できる
            formatter.dateFormat = "yyyy年MM月dd日HH時"
            //datePickerで指定した日付が表示される
            timeLe.text = "\(formatter.string(from: datePicker.date))"
            let pickerTime = datePicker.date
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
        self.taskNameLe.resignFirstResponder()
        self.taskDetailTxt.resignFirstResponder()
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
     return SCALE(value: 550)
    }

    //入力ごとに文字数をカウントする
    func textViewDidChange(_ textView: UITextView) {
        let str = taskDetailTxt.text
        let commentNum = taskDetailTxt.text.count
        //空白と改行を抽出して取り除く
        let newStr = String(str!.unicodeScalars
            .filter(CharacterSet.whitespacesAndNewlines.contains)
            .map(Character.init))
        let numLabel = commentNum - newStr.count
        if numLabel > 200 {
            self.taskDetailTxt.text = preContentTxt
            return
        }
        preContentTxt = taskDetailTxt.text
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
        singleDate = date
        // 日付のフォーマット
        let formatter = DateFormatter()
        //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できる
        formatter.dateFormat = "yyyy年MM月dd日HH時"
        //datePickerで指定した日付が表示される
        timeLe.text = "\(formatter.string(from: date))"
        let pickerTime = date
        resultDate = Common.calcDate(baseDate: pickerTime)
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        if let date = dates.first {
            singleDate = date
        }
        else {
        }
        multipleDates = dates
    }

    func checkEmptyFeild() -> Bool {
        
        if self.taskNameLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "タスク名"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.taskDetailTxt.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "タスク詳細"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.timeLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "タスク期限"+Config.INPUT_ERR_MSG)
            return false
        }
        
        return true
    }

    func setUI(_ view: UIButton) {
        let selectedColor = UIColor.systemBlue
        colorBtn1.layer.borderWidth = 0
        colorBtn2.layer.borderWidth = 0
        colorBtn3.layer.borderWidth = 0
        colorBtn4.layer.borderWidth = 0
        colorBtn5.layer.borderWidth = 0

        view.layer.borderWidth = 2
        view.layer.borderColor = selectedColor.cgColor
    }
    
    @IBAction func actionBtnClicked(_ sender: Any) {
        if self.editable {
            saveMemoData()
        }else {
            self.editable = !self.editable
            self.setEditingFeilds()
        }
    }

    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   func saveMemoData() {
//        if checkEmptyFeild() {
//            let todo:Todo = Todo(context: DatabaseManager.persistentContainer.viewContext)
//            todo.name = taskNameLe.text
//            todo.desc = taskDetailTxt.text
//            todo.bgColor = Config.TodoColors[selectedColorIndex]
//            todo.alertFlag = notificationSwitch.isOn
//            todo.completedFlag = false
//            todo.alertTime = resultDate
//            todo.createdAt = Date()
//            todo.completedAt = Date()
//
//            // 上で作成したデータをデータベースに保存
//            DatabaseManager.saveContext()
//            if todo.alertFlag {
//                let timeInterval = resultDate?.timeIntervalSince(Common.calcDate(baseDate: Date()))
//                if timeInterval != nil {
//                    LocalNotificationManager.addNotificaion(title: todo.name!, id: todo.name!+todo.bgColor!, time: timeInterval!)
//                }
//            }
//            //入力値をクリアにする
//            taskNameLe.text = ""
//            taskDetailTxt.text = ""
//            timeLe.text = ""
//
//            self.navigationController?.popViewController(animated: true)
//        }
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
                        LocalNotificationManager.removeNotification(id: self.todo!.name!+self.todo!.bgColor!)
                    }
                    // 編集の場合は詳細画面から渡されたself.memoを変更、
                    // 新規の場合は新しいMemoオブジェクトを作り、現在の日時を入れる_
                    let todo: Todo = {
                        if let todo = self.todo {
                            todo.createdAt = Date()
                            todo.alertTime = self.resultDate
                            return todo
                        } else {
                            let todo = Todo(context: DatabaseManager.persistentContainer.viewContext)
                            todo.createdAt = Date()
                            todo.alertTime = self.resultDate
                            return todo
                        }
                    }()
                    

                    todo.name = self.taskNameLe.text
                    todo.desc = self.taskDetailTxt.text
                    todo.bgColor = Config.TodoColors[self.selectedColorIndex]
                    todo.alertTime = self.resultDate
                    todo.alertFlag = self.notificationSwitch.isOn
                    todo.completedAt = Date()
                    todo.createdAt = Date()
                    todo.completedFlag = false
                    
                    if(todo.alertTime == nil){
                        todo.alertTime = self.nowdate
                    }
                    
             
                    let timeInterval = todo.alertTime?.timeIntervalSince(Common.calcDate(baseDate: Date()))
                    print("notifitime interval \(timeInterval!)")
                    if timeInterval != nil {
                        if timeInterval! > 0{
                            DatabaseManager.saveContext()
                            LocalNotificationManager.addNotificaion(title: todo.name!, id: todo.name!+todo.bgColor!, time: timeInterval!)
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
    func clearData()  {
        timeLe.text = ""
        taskNameLe.text = ""
        taskDetailTxt.text = ""
    }
    
    
    @IBAction func colorBtn1Clicked(_ sender: Any) {
        if #available(iOS 13.0, *) {
            colorBtn1.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        colorBtn2.setImage(nil, for: .normal)
        colorBtn3.setImage(nil, for: .normal)
        colorBtn4.setImage(nil, for: .normal)
        colorBtn5.setImage(nil, for: .normal)
        coloBtn6.setImage(nil, for: .normal)
        selectedColorIndex = 0
        setUI(colorBtn1)
    }
    @IBAction func colorBtn2Clicked(_ sender: Any) {
        if #available(iOS 13.0, *) {
            colorBtn2.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        colorBtn1.setImage(nil, for: .normal)
        colorBtn3.setImage(nil, for: .normal)
        colorBtn4.setImage(nil, for: .normal)
        colorBtn5.setImage(nil, for: .normal)
        coloBtn6.setImage(nil, for: .normal)
        selectedColorIndex = 1
        setUI(colorBtn2)
    }
    @IBAction func colorBtn3Clicked(_ sender: Any) {
        if #available(iOS 13.0, *) {
            colorBtn3.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        colorBtn2.setImage(nil, for: .normal)
        colorBtn1.setImage(nil, for: .normal)
        colorBtn4.setImage(nil, for: .normal)
        colorBtn5.setImage(nil, for: .normal)
        coloBtn6.setImage(nil, for: .normal)
        selectedColorIndex = 2
        setUI(colorBtn3)
    }
    @IBAction func colorBtn4Clicked(_ sender: Any) {
        if #available(iOS 13.0, *) {
            colorBtn4.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        colorBtn2.setImage(nil, for: .normal)
        colorBtn3.setImage(nil, for: .normal)
        colorBtn1.setImage(nil, for: .normal)
        colorBtn5.setImage(nil, for: .normal)
        coloBtn6.setImage(nil, for: .normal)
        selectedColorIndex = 3
        setUI(colorBtn4)
    }
    @IBAction func colorBtn5Clicked(_ sender: Any) {
        if #available(iOS 13.0, *) {
            colorBtn5.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        colorBtn2.setImage(nil, for: .normal)
        colorBtn3.setImage(nil, for: .normal)
        colorBtn4.setImage(nil, for: .normal)
        colorBtn1.setImage(nil, for: .normal)
        coloBtn6.setImage(nil, for: .normal)
        selectedColorIndex = 4
        setUI(colorBtn5)
    }
    
    @IBAction func colorBtn6Clicked(_ sender: Any) {
        if #available(iOS 13.0, *) {
            coloBtn6.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        colorBtn2.setImage(nil, for: .normal)
        colorBtn3.setImage(nil, for: .normal)
        colorBtn4.setImage(nil, for: .normal)
        colorBtn5.setImage(nil, for: .normal)
        colorBtn1.setImage(nil, for: .normal)
        selectedColorIndex = 5
        setUI(coloBtn6)
    }
    
    @IBAction func timeBtnClicked(_ sender: Any) {
        showCalendarSelecter()
    }

}
