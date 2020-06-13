//
//  MemoCollectionViewCell.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/21.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

@objc protocol MemoCollectionViewCellDelegate {
    func checkBtnClicked(section: Int, ind: Int, selected: Bool)
}

class MemoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var countLb: ScaledLabel!
    @IBOutlet weak var titleLb: ScaledLabel!
    @IBOutlet weak var contentLb: ScaledLabel!
    @IBOutlet weak var dateLb: ScaledLabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var checkImg: UIImageView!
    
    internal weak var delegate : MemoCollectionViewCellDelegate? = nil;

    var currentIndex: Int?
    var currentSection: Int?
    var selectedFlag: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.mainView.layer.cornerRadius = 10
        self.mainView.layer.masksToBounds = false
        self.mainView.layer.shadowRadius = 4
        self.mainView.layer.shadowOpacity = 1
        self.mainView.layer.shadowColor = UIColor.gray.cgColor
        self.mainView.layer.shadowOffset = CGSize(width: 0 , height:2)
    }
    
    internal func initData(memoData: Memo, section: Int, ind: Int, editable: Bool) {
        self.currentIndex = ind
        self.currentSection = section
        countLb.text = memoData.memoNum! + " 文字"
        titleLb.text = memoData.title
        contentLb.text = memoData.memoText
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        formatter.dateFormat = "yyyy年MM月dd日HH時"
        let date = formatter.date(from: memoData.memoDate!)
        
        formatter.dateFormat = "MM/dd HH:mm"

        dateLb.text = formatter.string(from: date!)
        
        self.selectedFlag = editable
        if selectedFlag {
            checkImg.image = UIImage(named: "check")
        }else {
            checkImg.image = UIImage(named: "uncheck")
        }
    }
    
    @IBAction func checkBtnClicked(_ sender: Any) {
        selectedFlag = !selectedFlag
        if selectedFlag {
            checkImg.image = UIImage(named: "check")
        }else {
            checkImg.image = UIImage(named: "uncheck")
        }
        delegate?.checkBtnClicked(section: currentSection!, ind: currentIndex!, selected: selectedFlag)
    }
    
    
    
}
