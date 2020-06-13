//
//  TopViewController.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/09/28.
//  Copyright © 2019 ADV. All rights reserved.
//

import UIKit

class TopViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
