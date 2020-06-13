//
//  AccountViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/22.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController
, UIPickerViewDelegate
, UIPickerViewDataSource
, UITableViewDelegate
, UITableViewDataSource
, UITextViewDelegate
, UIImagePickerControllerDelegate
, UINavigationControllerDelegate
, WWCalendarTimeSelectorProtocol
{
    internal var users:UserProfile? = nil
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewCell: UITableViewCell!
    //@IBOutlet weak var avataImg: UIImageView!
    
    @IBOutlet weak var yearText: UITextView!
    
    @IBOutlet weak var threeText: UITextView!
    @IBOutlet weak var seconText: UITextView!
    @IBOutlet weak var memoTypeLe: UITextField!
    
    @IBOutlet weak var endle: UITextField!
    @IBOutlet weak var userNameLe: UITextField!
    
    @IBOutlet weak var emailLe: UITextField!
    
    @IBOutlet weak var passwordLe1: UITextField!
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []

    //@IBOutlet weak var editBtn: UIButton!
    //@IBOutlet weak var saveBtn: UIButton!
    
    
    private var selectedTypeIndex: Int = 0
    private var editable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.alwaysBounceVertical = false
        
        var user:[UserProfile] = []
        user = DatabaseManager.getUseroDatas()
        if(user.count < 1){
            userNameLe.text = ""
                   memoTypeLe.text = ""
                   yearText.text = ""
                   seconText.text = ""
                   threeText.text = ""
        }else{
        userNameLe.text = user[user.count-1].username
        memoTypeLe.text = user[user.count-1].graduateYear
        yearText.text = user[user.count-1].education
        seconText.text = user[user.count-1].qualification
        threeText.text = user[user.count-1].hobby
            
        }
        
//        userNameLe.text = todoItems
//        memoTypeLe.text = users?.graduateYear
//        yearText.text = users?.education
//        seconText.text = users?.qualification
//        threeText.text = users?.hobby
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (Common.me == nil) {
            editable = true
        }else {
            memoTypeLe.text = Config.MemoTypeData[Common.me!.memoType]
            userNameLe.text = Common.me!.userName
            emailLe.text = Common.me!.email
//            if Common.me!.avata != "" {
//                userImg = Common.loadImageFromDiskWith(fileName: Common.me!.avata)
//                avataImg.image = userImg
//            }
        }
        setEditingFeilds()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setEditingFeilds() {
        self.memoTypeLe.isEnabled = self.editable
        self.userNameLe.isEnabled = self.editable
        self.emailLe.isEnabled = self.editable
        self.passwordLe1.isEnabled = self.editable

        if self.editable {
            //editBtn.isHidden = true
            //saveBtn.isHidden = false
//            passwordLe1.isHidden = false
//            endle.isHidden = false
//            emailLe.isHidden = false
            yearText.isEditable = true
            threeText.isEditable = true
            seconText.isEditable = true
        }else {
            //editBtn.isHidden = false
            //saveBtn.isHidden = true
//            passwordLe1.isHidden = true
//            endle.isHidden = true
//            emailLe.isHidden = true
            yearText.isEditable = false
            threeText.isEditable = false
            seconText.isEditable = false
            
        }
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

        self.userNameLe.inputAccessoryView = doneToolbar
        self.emailLe.inputAccessoryView = doneToolbar
        self.yearText.inputAccessoryView = doneToolbar
        self.seconText.inputAccessoryView = doneToolbar
        self.threeText.inputAccessoryView = doneToolbar
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
        self.userNameLe.resignFirstResponder()
        self.emailLe.resignFirstResponder()
        self.yearText.resignFirstResponder()
        self.seconText.resignFirstResponder()
        self.threeText.resignFirstResponder()
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
        return SCALE(value: 600)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Config.MemoTypeData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Config.MemoTypeData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTypeIndex = row
        memoTypeLe.text = Config.MemoTypeData[row]
    }

    func checkEmptyFeild() -> Bool {
        
        if self.memoTypeLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "卒業年度"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.userNameLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "アカウント名"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.yearText.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "学歴職歴"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.threeText.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "資格免許"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.seconText.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "趣味特技"+Config.INPUT_ERR_MSG)
            return false
        }
        
        return true
    }

    @IBAction func memoTypeBtnClicked(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: Config.SCREEN_WIDTH,height: 150)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: Config.SCREEN_WIDTH, height: 150))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(selectedTypeIndex, inComponent: 0, animated: false)
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "卒業年度", message: nil, preferredStyle: .actionSheet)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            editRadiusAlert.dismiss(animated: true, completion: nil)
        }))
        present(editRadiusAlert, animated: true, completion: nil)
//        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
//                   selector.delegate = self
//                   selector.optionCurrentDate = singleDate
//                   selector.optionCurrentDates = Set(multipleDates)
//                   selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
//                   selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
//
//                   present(selector, animated: true, completion: nil)
//               }
//               
//               func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
//                   print("Selected \n\(date)\n---")
//                   singleDate = date
//                   // 日付のフォーマット
//                   let formatter = DateFormatter()
//                   //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できる
//                   formatter.dateFormat = "yyyy年MM月dd日"
//                   //datePickerで指定した日付が表示される
//                   memoTypeLe.text = "\(formatter.string(from: date))"
//               }
//               
//               func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
//                   print("Selected Multiple Dates \n\(dates)\n---")
//                   if let date = dates.first {
//                       singleDate = date
//                   }
//                   else {
//                   }
//                   multipleDates = dates
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        if checkEmptyFeild() {
            let alert: UIAlertController = UIAlertController(title: "確認", message: "作業を完了しましたか？", preferredStyle:  UIAlertController.Style.alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
                // OKボタン押下時のイベント
              
            let okAction = UIAlertAction(title: "OK", style: .default) {
                (action) in
            let users: UserProfile = {
                if let users = self.users {
                    users.graduateYear = self.memoTypeLe.text
                    return users
                } else {
                    let users = UserProfile(context: DatabaseManager.persistentContainer.viewContext)
                    return users
                }
            }()
                users.username = self.userNameLe.text
                users.graduateYear = self.memoTypeLe.text
                users.education = self.yearText.text
                users.qualification = self.seconText.text
                users.hobby = self.threeText.text
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let delegateObj = AppDelegate.instance();
                let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "homepage") as UIViewController
                vc.modalPresentationStyle = .fullScreen
                delegateObj.window?.rootViewController!.present(vc, animated: true, completion: {
                })
                DatabaseManager.saveContext()
                self.editable = !self.editable
                self.setEditingFeilds()
                self.navigationController?.pushViewController(vc, animated: true)
                self.tabBarController?.tabBar.isHidden = false

            }
                        
                alert.dismiss(animated: true, completion: nil)

                // UIAlertControllerにActionを追加
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                
                // Alertを表示
                present(alert, animated: true, completion: nil)
                
            }
        }
    
     @IBAction func avataBtnClicked(_ sender: Any) {
            if editable {
                let alert: UIAlertController = UIAlertController(title: "画像の選択",
                                                                 message: "",
                                                                 preferredStyle: .actionSheet);
                let registerAction: UIAlertAction = UIAlertAction(title: "写真を撮影", style: .default, handler: {
                    (action: UIAlertAction!) -> Void in
                    let vc = UIImagePickerController()
                    vc.sourceType = .camera
                    vc.allowsEditing = true
                    vc.delegate = self
                    self.present(vc, animated: true)
                })
                let loginAction: UIAlertAction = UIAlertAction(title: "アルバムから選択", style: .default, handler: {
                    (action: UIAlertAction!) -> Void in
                    let vc = UIImagePickerController()
                    vc.sourceType = .photoLibrary
                    vc.allowsEditing = true
                    vc.delegate = self
                    self.present(vc, animated: true)
                })
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル",
                                                                style: .cancel,
                                                                handler: nil)
                alert.addAction(registerAction)
                alert.addAction(loginAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            }
    }
    
}
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true)
//
//        guard let image = info[.editedImage] as? UIImage else {
//            return
//        }
//        //self.avataImg.image = image
//        self.userImg = image
//    }


   



