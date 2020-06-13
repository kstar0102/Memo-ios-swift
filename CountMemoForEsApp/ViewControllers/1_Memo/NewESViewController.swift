
import UIKit

class NewESViewController: UIViewController
, WWCalendarTimeSelectorProtocol {

    @IBOutlet weak var titleLe: UITextField!
    
    @IBOutlet weak var companyLe: UITextField!
    
    @IBOutlet weak var endDateLe: UITextField!
    
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    var preContentTxt:String = ""

    //UIDatePickerを定義するための変数
    var datePicker: UIDatePicker = UIDatePicker()
    //resultDateで１日前を日付計算
    var resultDate:Date?

    var memo:Memo? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        let placeHolder = NSAttributedString(string: "ESタイトル", attributes:  [NSAttributedString.Key.foregroundColor: UIColor.white])
        titleLe.attributedPlaceholder = placeHolder

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        self.titleLe.becomeFirstResponder()

        addDoneButtonOnKeyboard()

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
        self.titleLe.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        self.companyLe.resignFirstResponder()
        self.titleLe.resignFirstResponder()
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
        endDateLe.text = "\(formatter.string(from: date))"
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
        
        if self.titleLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "ESタイトル"+Config.INPUT_ERR_MSG)
            return false
        }
        
        if self.endDateLe.text == "" {
            Common.showErrorAlert(vc: self, title: Config.INPUT_ERR_TITLE, message: "締切日時"+Config.INPUT_ERR_MSG)
            return false
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

                        memo.title = self.titleLe.text
                        memo.company = self.companyLe.text
                        memo.memoDate = self.endDateLe.text
                        memo.memoText = ""
                        memo.alertDate = self.resultDate
                        memo.memoNum = "0"

                        // 上で作成したデータをデータベースに保存
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
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func endDateClicked(_ sender: Any) {
        showCalendarSelecter()
    }
    
    @IBAction func goToContentView(_ sender: Any) {
        if checkEmptyFeild() {
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

            memo.title = self.titleLe.text
            memo.company = self.companyLe.text
            memo.memoDate = self.endDateLe.text
            memo.memoText = ""
            memo.alertDate = self.resultDate
            memo.memoNum = "0"

            let vc = NewESContentViewController()
            vc.memo = memo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 入力値をクリア
    func clearData()  {
        companyLe.text = ""
        titleLe.text = ""
        endDateLe.text = ""
    }

    @IBAction func saveBtnClicked(_ sender: Any) {
        saveMemoData()
    }
    
    
}
