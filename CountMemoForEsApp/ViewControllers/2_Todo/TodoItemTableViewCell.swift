//
//  TodoItemTableViewCell.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/23.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

@objc protocol TodoItemComplitedViewCellDelegate {
    func deleteCompleted(section: Int, ind: Int)
    func checkBtnClicked(section:Int, ind:Int)
}

class TodoItemTableViewCell: UITableViewCell {

    @IBOutlet weak var markView: UIView!
    
    @IBOutlet weak var dayLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    
    @IBOutlet weak var titleLb: ScaledLabel!
    
    @IBOutlet weak var dateLb: ScaledLabel!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var checkImg: UIImageView!
    internal weak var delegate : TodoItemComplitedViewCellDelegate? = nil;

    var currentIndex: Int?
    var currentSection: Int?
    var selectedFlag: Bool?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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

    }
   
    internal func initData(todoData: Todo, section: Int, ind: Int) {
        self.currentIndex = ind
        self.currentSection = section

        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: todoData.name!)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        titleLb.attributedText = attributeString;

        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        formatter.dateFormat = "yyyy年MM月dd日HH時"
        self.dateLb.text = formatter.string(from: todoData.createdAt!)

        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "d"
        timeLb.text = formatter.string(from: todoData.alertTime!)
        
        formatter.dateFormat = "EEEE"
        dayLb.text = formatter.string(from: todoData.alertTime!)

        let timeInterval = todoData.alertTime?.timeIntervalSince(Date())
        if timeInterval != nil {
            if timeInterval! <= 0 {
                markView.backgroundColor = .lightGray
                selectedFlag = true
            }
        }
    }
    @IBAction func deleteCompleted(_ sender: Any) {
           delegate?.deleteCompleted(section: currentSection!, ind: currentIndex!)
       }
    @IBAction func selectCheck(_ sender: Any) {
            delegate?.checkBtnClicked(section:currentSection!, ind: currentIndex!)
    }
    
}
