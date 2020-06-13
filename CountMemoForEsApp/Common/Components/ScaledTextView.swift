//
//  ScaledTextView.swift
//  Manga
//
//  Created by TopFlyingDragon on 2016/11/03.
//  Copyright © 2016年 juc com. All rights reserved.
//

import UIKit

class ScaledTextView: UITextView {

    var designFont : UIFont?
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        designFont = self.font;
        if(designFont != nil){
            self.font = designFont?.withSize((designFont!.pointSize) * Config.SCALE);
        }
    }

}
