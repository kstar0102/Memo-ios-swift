
import UIKit



class calendarTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var sideView: UIView!
    
    var currentIndex:Int?
    override func awakeFromNib() {
        
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = false
        mainView.layer.shadowRadius = 4
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowColor = UIColor.gray.cgColor
        mainView.layer.shadowOffset = CGSize(width: 1 , height:2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func initData(todoData:Todo, ind:Int){
        self.currentIndex = ind
        titleLb.text = todoData.name
        sideView.backgroundColor = UIColor(hexString: todoData.bgColor!)
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")as Locale
        formatter.dateFormat = "yyyy年MM月dd日HH時"
        self.dateLb.text = formatter.string(from: todoData.alertTime!)
        //dateLb.text = todoData.al
    }
}
