//
//  MemoTabBarController.swift
//  CountMemoForEsApp
//
//  Created by 石川陽子 on 2019/02/09.
//  Copyright © 2019年 Yoko Ishikawa. All rights reserved.
//

import UIKit

class MemoTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        UITabBar.appearance().barTintColor = UIColor.darkGray
        
        // Addボタンをオリジナル画像で表示する
        let addTabBarItem = self.tabBar.items?[2]
        let addImage = UIImage(named: "addmemo3030")?.withRenderingMode(.alwaysOriginal)
        addTabBarItem?.image = addImage
        addTabBarItem?.selectedImage = addImage
    }
    
}
