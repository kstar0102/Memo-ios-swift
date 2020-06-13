//
//  Todolist CollectionViewCell.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/04/08.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit
@objc protocol TodoItemCollectViewCellDelegate {
    func checkBtnClicked(ind: Int)
}

class Todolist_CollectionViewCell: UICollectionViewCell {

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


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.markView.layer.cornerRadius = 20
    }
    
    internal func initData(todoData: Todo, ind: Int) {
        self.currentIndex = ind
        titleLb.text = todoData.name
        
        self.mainView.layer.cornerRadius = 10
        self.mainView.layer.masksToBounds = false
        self.mainView.layer.shadowRadius = 4
        self.mainView.layer.shadowOpacity = 1
        self.mainView.layer.shadowColor = UIColor.gray.cgColor
        self.mainView.layer.shadowOffset = CGSize(width: 0 , height:2)

        if todoData.completedFlag {
            checkImg.image = UIImage(named: "check")
        }else {
            checkImg.image = UIImage(named: "uncheck")
        }
        selectedFlag = todoData.completedFlag

        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        formatter.dateFormat = "yyyy年MM月dd日HH時"
        self.dateLb.text = formatter.string(from: todoData.createdAt!)

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
        }else {
            markView.backgroundColor = .white
        }
    }

    @IBAction func checkBtnClicked(_ sender: Any) {
        if !selectedFlag! {
            delegate?.checkBtnClicked(ind: currentIndex!)
        }
    }

}
