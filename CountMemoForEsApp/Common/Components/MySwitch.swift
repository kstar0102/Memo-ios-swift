//
//  MySwitch.swift
//  Manga
//
//  Created by TopFlyingDragon on 2016/10/29.
//  Copyright © 2016年 juc com. All rights reserved.
//

import UIKit

class MySwitch: UISwitch {

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.onTintColor = Config.BASE;
        self.tintColor = Config.GRAY;
        self.layer.cornerRadius = 16.0;
        self.backgroundColor = Config.GRAY;
    }
    
}
