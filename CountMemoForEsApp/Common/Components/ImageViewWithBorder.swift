//
//  ImageViewWithBorder.swift
//  Manga
//
//  Created by juc com on 12/9/16.
//  Copyright © 2016 juc com. All rights reserved.
//

import UIKit

var color :UIColor?

class ImageViewWithBorder: UIImageView {

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.layer.borderWidth = 1.0;
        color = UIColor(named: "#e9e9e9");
        self.layer.borderColor = color?.cgColor;
    }
}
