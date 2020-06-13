//
//  TodoListCollectionViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/04/08.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit
import XLPagerTabStrip

@objc protocol TodoListTableViewControllerDelegate {
    func totoCompleted()
}

class TodoListCollectionViewController: UICollectionViewController
, TodoItemCollectViewCellDelegate
, IndicatorInfoProvider {

    internal var itemInfo = IndicatorInfo(title: "View")
        internal var selectedIndex: Int = 0
        internal var delegate: TodoListTableViewControllerDelegate?

        let cellIdentifier = "TodoItemTableViewCell"
        private var tableData : NSMutableArray = NSMutableArray()
        private var todoItems:[Todo] = []
        private var groupedTodoList: NSMutableArray!
        private var groupKeyList: NSMutableArray!
        private var deleteMemoList: NSMutableArray!

        override func viewDidLoad() {
            super.viewDidLoad()

            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
            layout.itemSize = CGSize(width: Config.SCREEN_WIDTH-15, height: 100)
            layout.headerReferenceSize = CGSize(width:0, height:40)
            layout.sectionHeadersPinToVisibleBounds = true
            self.collectionView.register(UINib(nibName: "Todolist_CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Todolist_CollectionViewCell")
            self.collectionView.register(UINib(nibName: "TodoCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TodoCollectionReusableView");
            self.collectionView.delegate = self
            self.collectionView.dataSource = self

        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            initDatas()
        }
        
        internal func initDatas() {
            todoItems = DatabaseManager.getTodoDatas(completed: false)
            collectionView.reloadData()
        }
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return todoItems.count
        }

        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell:Todolist_CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Todolist_CollectionViewCell", for: indexPath) as! Todolist_CollectionViewCell;
    //        let memoDatas = self.groupedTodoList.object(at: indexPath.section) as! [Memo]
    //        cell.initData(todoData: memoDatas[indexPath.row], ind: indexPath.row)
            cell.initData(todoData: todoItems[indexPath.row], ind: indexPath.row)
            cell.delegate = self

            return cell;
        }
        
        override func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return groupKeyList.count
            return 1
        }

        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let vc = MemoViewController()
    //        vc.editType = "edit"
    //        let memoDatas = self.groupedTodoList.object(at: indexPath.section) as! [Memo]
    //        vc.memo = memoDatas[indexPath.row]
    //        self.navigationController?.pushViewController(vc, animated: true)
    //        self.tabBarController?.tabBar.isHidden = true
        }

        override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TodoCollectionReusableView", for: indexPath) as! TodoCollectionReusableView

    //            reusableview.initData(groupTitle: (self.groupKeyList[indexPath.section] as! String))
                reusableview.initData(groupTitle: "3Month")
                return reusableview
            default:  fatalError("Unexpected element kind")
            }
        }
        
        func loadMemoData(key: String) {
            var memoData:[Memo] = []
            memoData = DatabaseManager.getSearchDatas(keyword: key)
            groupedTodoList.removeAllObjects()
            groupKeyList.removeAllObjects()

            for i in 0 ..< memoData.count {
                if !groupKeyList.contains(memoData[i].company!) {
                    groupKeyList.add(memoData[i].company!)
                }else {
                    continue
                }
            }
            for i in 0 ..< groupKeyList.count {
                var memoItems:[Memo] = []
                for j in 0 ..< memoData.count {
                    if (groupKeyList.object(at: i) as! String) == memoData[j].company {
                        memoItems.append(memoData[j])
                    }
                }
                groupedTodoList.add(memoItems)
            }
            self.collectionView.reloadData()
        }

        // MARK: - IndicatorInfoProvider

        func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
            return itemInfo
        }
        
        func checkBtnClicked(ind: Int) {
            let selectedTodo = todoItems[ind]
            selectedTodo.completedAt = Date()
            selectedTodo.completedFlag = true
            // 上で作成したデータをデータベースに保存
            DatabaseManager.saveContext()
            initDatas()
            delegate?.totoCompleted()
        }

    }
