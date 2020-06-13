//
//  TodoCollectionReusableView.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/04/08.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class TodoCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    internal func initData(groupTitle: String) {
        titleLb.text = groupTitle + "月"
    }

}
