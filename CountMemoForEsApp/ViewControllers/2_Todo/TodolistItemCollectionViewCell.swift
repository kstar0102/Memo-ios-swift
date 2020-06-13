
import UIKit
@objc protocol TodoItemCollectViewCellDelegate {
    func checkBtnClicked(section: Int, ind: Int)
    func deleteBtnClicked(section: Int, ind: Int)
}

class TodolistItemCollectionViewCell: UICollectionViewCell {

        @IBOutlet weak var markView: UIView!
        
        @IBOutlet weak var timeLb: UILabel!    
        @IBOutlet weak var weekLb: UILabel!
        @IBOutlet weak var titleLb: ScaledLabel!
        
        @IBOutlet weak var dateLb: ScaledLabel!
        @IBOutlet weak var mainView: UIView!
        
        @IBOutlet weak var checkImg: UIImageView!
        internal weak var delegate : TodoItemCollectViewCellDelegate? = nil;

        var currentIndex: Int?
        var selectedFlag: Bool?
        var currentSection: Int?
        var currentId: NSObject?


        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            self.markView.layer.cornerRadius = 20
        }
        
    internal func initData(todoData: Todo, section: Int, ind: Int) {
            self.currentIndex = ind
            self.currentSection = section
            titleLb.text = todoData.name
            
            self.mainView.layer.cornerRadius = 10
            self.mainView.layer.masksToBounds = false
            self.mainView.layer.shadowRadius = 4
            self.mainView.layer.shadowOpacity = 1
            self.mainView.layer.shadowColor = UIColor.gray.cgColor
            self.mainView.layer.shadowOffset = CGSize(width: 0 , height:2)
        
            self.markView.layer.cornerRadius = 20
            self.markView.layer.borderColor = UIColor.gray.cgColor
            self.markView.layer.borderWidth = 1
            self.markView.layer.masksToBounds = false
            self.markView.layer.shadowRadius = 2
            self.markView.layer.shadowOpacity = 1
            self.markView.layer.shadowColor = UIColor.gray.cgColor
            self.markView.layer.shadowOffset = CGSize(width: 0 , height:2)

            if todoData.completedFlag {
                checkImg.image = UIImage(named: "check")
            }else {
                checkImg.image = UIImage(named: "uncheck")
            }
            selectedFlag = todoData.completedFlag

            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
            formatter.dateFormat = "yyyy年MM月dd日HH時"
            self.dateLb.text = formatter.string(from: todoData.alertTime!)

            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.dateFormat = "EEEE"
            weekLb.text = formatter.string(from:todoData.alertTime!)
            formatter.dateFormat = "dd"
            timeLb.text = formatter.string(from: todoData.alertTime!)

            let currentDate = Date()
            formatter.dateFormat = "yyyy"
            let currentYear = formatter.string(from: currentDate)
            let alertYear = formatter.string(from: todoData.alertTime!)

            formatter.dateFormat = "MM"
            let currentMonth = formatter.string(from: currentDate)
            let alertMonth = formatter.string(from: todoData.alertTime!)
            
            formatter.dateFormat = "dd"
            let currentDay = formatter.string(from: currentDate)
            let alertDay = formatter.string(from: todoData.alertTime!)

            if currentYear == alertYear &&
                currentMonth == alertMonth &&
                currentDay == alertDay {
                markView.backgroundColor = UIColor(hexString: "3F3F3F")
                timeLb.textColor = .white
            }else {
                markView.backgroundColor = .white
                timeLb.textColor = .black
            }
        }

   
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.deleteBtnClicked(section:currentSection!, ind: currentIndex!)
    }
    @IBAction func checkBtnClicked(_ sender: Any) {
            if !selectedFlag! {
                delegate?.checkBtnClicked(section:currentSection!, ind: currentIndex!)
            }
        }

    }
