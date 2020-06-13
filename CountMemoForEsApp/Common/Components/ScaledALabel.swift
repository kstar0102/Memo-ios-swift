//
//  ScaledALabel.swift
//  Manga
//
//  Created by TopFlyingDragon on 2016/11/05.
//  Copyright © 2016年 juc com. All rights reserved.
//

import UIKit

class ScaledALabel: UILabel {
    var designFont : UIFont?
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        designFont = self.font;
        if(designFont != nil){
            let newFont = designFont!.withSize((designFont!.pointSize) * Config.SCALE);
            
            let para = NSMutableParagraphStyle();
            para.lineHeightMultiple = 1.3;
            let aStr :NSMutableAttributedString = NSMutableAttributedString(string: self.text!);
            aStr.addAttributes([
                NSAttributedString.Key.font: newFont,
                NSAttributedString.Key.foregroundColor: self.textColor as Any,
                NSAttributedString.Key.paragraphStyle: para
                ], range: NSMakeRange(0, aStr.length)
            );
            self.attributedText = aStr;
        }
    }

}
