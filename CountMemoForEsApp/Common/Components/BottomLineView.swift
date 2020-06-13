//
//  BottomLineView.swift
//  Manga
//
//  Created by TopFlyingDragon on 2016/10/29.
//  Copyright © 2016年 juc com. All rights reserved.
//

import UIKit

class BottomLineView: UIView {

    var color :UIColor?
    var lineView : UIView = UIView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        color = self.backgroundColor;
        color = UIColor(named: "#bbbbbb");
        self.backgroundColor = UIColor.clear;
        
        let w = BORDER_WIDTH();
        lineView = UIView(frame:CGRect(x: 0, y: self.frame.size.height-w-0.2, width: self.frame.size.width, height: w))
        lineView.backgroundColor = color;
        self.addSubview(lineView)
    }
    
    override func draw(_ rect: CGRect)
    {
        if(abs(rect.size.width - lineView.frame.size.width)>1){
            lineView.frame.size = CGSize(width: rect.size.width, height: BORDER_WIDTH());
        }
    }

}
