//
//  BaseViewController.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/09/28.
//  Copyright © 2019 ADV. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func loadView() {
        if #available(iOS 9, *) {
            super.loadView()
        } else {
            let classString = String.init(describing: type(of: self))
            Bundle.main.loadNibNamed(classString, owner: self, options: nil)
        }
    }
    
    override var nibName: String? {
        get {
            let classString = String.init(describing: type(of: self))
            return classString
        }
    }
    override var nibBundle: Bundle? {
        get {
            return Bundle.main
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
