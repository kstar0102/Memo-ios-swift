//
//  ScaleTextField.swift
//  Manga
//
//  Created by TopFlyingDragon on 2016/11/06.
//  Copyright © 2016年 juc com. All rights reserved.
//

import UIKit

class ScaleTextField: UITextField {

    var designFont : UIFont?
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        designFont = self.font;
        if(designFont != nil){
            self.font = designFont?.withSize((designFont!.pointSize) * Config.SCALE);
        }
    }
    

}
