//
//  BackButtonViewController.swift
//  Manga
//
//  Created by TopFlyingDragon on 2016/10/29.
//  Copyright © 2016年 juc com. All rights reserved.
//

import UIKit

class BackButtonViewController: BaseViewController, UIGestureRecognizerDelegate {

    var button: UIButton?
    
    //-------------------------------------------------------------------------------------------------------------------------
    //                                              View Did Load
    //-------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
    }
    //-------------------------------------------------------------------------------------------------------------------------
    //                                              View Will Load
    //-------------------------------------------------------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        // add back button
        if(button==nil){
            let image = UIImage(named: "back_btn") as UIImage?
            button = UIButton(type: UIButton.ButtonType.custom) as UIButton
            button!.frame = CGRect(x: SCALE(value: 20), y: Config.SCREEN_HEIGHT-SCALE(value: 120), width: SCALE(value: 43), height: SCALE(value: 43));
            button!.setBackgroundImage(image, for: .normal)
            button!.addTarget(self, action: #selector(BackButtonViewController.backClicked), for:.touchUpInside)
            self.view.addSubview(button!)
        }
    }
    //-------------------------------------------------------------------------------------------------------------------------
    //                                              Back Button Clicked
    //-------------------------------------------------------------------------------------------------------------------------
    @objc func backClicked(){
        self.navigationController?.popViewController(animated: true);
    }
}
