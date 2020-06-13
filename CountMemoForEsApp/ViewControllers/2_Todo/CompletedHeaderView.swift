//
//  CompletedHeaderView.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/04/14.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class CompletedHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier: String = String(describing: self)
    static var nib:UINib{
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    @IBOutlet var headView: UIView!
    @IBOutlet override var textLabel: UILabel?{
        get{return _textLabel}
        set{ _textLabel = newValue}
    }
    private var _textLabel: UILabel?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoter: NSCoder) {
        super.init(coder: aDecoter)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
