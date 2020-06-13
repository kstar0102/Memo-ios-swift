//
//  MyTabBar.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/09/28.
//  Copyright © 2019 ADV. All rights reserved.
//

import UIKit

class MyTabBar: UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        //sizeThatFits.height = 75 * Config.SCALE
        
        return sizeThatFits
    }
}
