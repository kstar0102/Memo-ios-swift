//
//  MemoHeaderCollectionReusableView.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/22.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class MemoHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var markBg: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        markBg.layer.cornerRadius = 2
    }
    
    internal func initData(markNum: Int, groupTitle: String) {
        titleLb.text = groupTitle
    }
    
}
