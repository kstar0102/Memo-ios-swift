//
//  TodoViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/22.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TodoViewController: ButtonBarPagerTabStripViewController
, IndicatorInfoProvider
, TodoListTableViewControllerDelegate {

    internal var itemInfo = IndicatorInfo(title: "View")

    @IBOutlet weak var addBtnView: UIView!
    private var vc1: TodoListTableViewController?
    private var vc2: CompletedTaskTableViewController?
    
    var screenWidth:CGFloat=0
    var screenHeight:CGFloat=0

    private var selectedIndex: Int = 0;

    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true

        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = UIColor(hexString: "30C4A4")!
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 17)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor(hexString: "30C4A4")!
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0

        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = UIColor(hexString: "30C4A4")!
        }
        
        self.addBtnView.layer.cornerRadius = 35
        self.addBtnView.layer.masksToBounds = false
        self.addBtnView.layer.shadowRadius = 4
        self.addBtnView.layer.shadowOpacity = 1
        self.addBtnView.layer.shadowColor = UIColor.gray.cgColor
        self.addBtnView.layer.shadowOffset = CGSize(width: 0 , height:2)

        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        vc1?.initDatas()
        vc2?.initDatas()
    }

    // MARK: - PagerTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let layout = UICollectionViewFlowLayout()
        vc1 = TodoListTableViewController(collectionViewLayout: layout)
        vc1?.itemInfo = "未完了"
        vc1?.delegate = self
        vc2 = CompletedTaskTableViewController()
        vc2?.itemInfo = "完了済み"
        return [vc1!, vc2!]
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        let vc = AddTodoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }

    func totoCompleted() {
    }
    

}
