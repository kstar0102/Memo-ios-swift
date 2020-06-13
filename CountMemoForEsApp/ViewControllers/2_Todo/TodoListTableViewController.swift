
import UIKit
import XLPagerTabStrip

@objc protocol TodoListTableViewControllerDelegate {
    func totoCompleted()
}

class TodoListTableViewController: UICollectionViewController
, UICollectionViewDelegateFlowLayout
, TodoItemCollectViewCellDelegate
, IndicatorInfoProvider {
    
    internal var itemInfo = IndicatorInfo(title: "View")
    internal var selectedIndex: Int = 0
    internal var delegate: TodoListTableViewControllerDelegate?

    let cellIdentifier = "TodoItemTableViewCell"
    private var tableData : NSMutableArray = NSMutableArray()
    private var todoItems1:[Todo] = []
    private var groupedTodoList: NSMutableArray!
    private var groupKeyList: NSMutableArray!
    private var deleteTodoList: NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: Config.SCREEN_WIDTH-15, height: 100)
        layout.headerReferenceSize = CGSize(width:0, height:40)
        layout.sectionHeadersPinToVisibleBounds = true
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView.register(UINib(nibName: "TodolistItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TodolistItemCollectionViewCell")
        self.collectionView.register(UINib(nibName: "TodoCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TodoCollectionReusableView");
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .white
        
        deleteTodoList = NSMutableArray()
        groupedTodoList = NSMutableArray()
        groupKeyList = NSMutableArray()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initDatas()
    }
    
    internal func initDatas() {
        var todoItems1:[Todo] = []
        todoItems1 = DatabaseManager.getTodoDatas(completed: false)
        groupedTodoList.removeAllObjects()
        groupKeyList.removeAllObjects()
        for i in 0..<todoItems1.count{
            if !groupKeyList.contains(todoItems1[i].alertTime?.month as Any){
                groupKeyList.add(todoItems1[i].alertTime?.month as Any)
            }else{
                continue
            }
        }
        for i in 0 ..< groupKeyList.count{
            var todoItems2:[Todo] = []
            for j in 0 ..< todoItems1.count{
                if (groupKeyList.object (at: i) as! intmax_t) == todoItems1[j].alertTime?.month{
                    todoItems2.append(todoItems1[j])
                }
            }
            todoItems2.sort(){$0.alertTime!.day < $1.alertTime!.day}
            groupedTodoList.add(todoItems2)
        }
        self.collectionView.reloadData()
        if todoItems1.count >= 1{
            self.collectionView.backgroundView = UIImageView(image: UIImage(named: "todoq"))
        }else{
           self.collectionView.backgroundView = UIImageView(image: UIImage(named: "todo"))
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupKeyList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let todoDatas = self.groupedTodoList.object(at: section) as! [Todo]
        return todoDatas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TodolistItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodolistItemCollectionViewCell", for: indexPath) as! TodolistItemCollectionViewCell;
        var tododatas = self.groupedTodoList.object(at: indexPath.section) as! [Todo]
        deleteTodoList.contains(tododatas[indexPath.row])
        cell.initData(todoData: tododatas[indexPath.row], section: indexPath.section, ind: indexPath.row)
        cell.delegate = self
        return cell;
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TodoCollectionReusableView", for: indexPath) as! TodoCollectionReusableView
            let title = "\(self.groupKeyList[indexPath.section])"
            reusableview.initData(groupTitle: title)
            return reusableview
        default:  fatalError("Unexpected element kind")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AddTodoViewController()
        vc.editType = "edit"
        let memoDatas = self.groupedTodoList.object(at: indexPath.section) as! [Todo]
        vc.todo = memoDatas[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func checkBtnClicked(section:Int, ind: Int) {
        let tododatas = self.groupedTodoList.object(at: section) as! [Todo]
        let selectedTodo = tododatas[ind]
        
        // 上で作成したデータをデータベースに保存
        
        self.groupedTodoList.replaceObject(at: section, with: tododatas)
        let alert: UIAlertController = UIAlertController(title: "確認", message: "作業を完了しましたか？", preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            selectedTodo.completedAt = Date()
            selectedTodo.completedFlag = true
            DatabaseManager.saveContext()
            self.delegate?.totoCompleted()
            self.initDatas()
            self.collectionView.reloadData()
            self.deleteTodoList.removeAllObjects()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteBtnClicked(section: Int, ind:Int) {
        var tododatas = self.groupedTodoList.object(at: section) as! [Todo]
        DatabaseManager.persistentContainer.viewContext.delete(tododatas[ind])
        LocalNotificationManager.removeNotification(id: tododatas[ind].name!+tododatas[ind].desc!)

        tododatas.remove(at: ind)
        
        self.groupedTodoList.replaceObject(at: section, with: tododatas)
        let alert: UIAlertController = UIAlertController(title: "注意", message: "削除してもよろしいですか？\n（１度削除したデータは復元できません。）", preferredStyle:  UIAlertController.Style.actionSheet)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            for i in 0 ..< self.deleteTodoList.count {
               let Todo = self.deleteTodoList.object(at: i) as! Todo
                DatabaseManager.persistentContainer.viewContext.delete(Todo)
                LocalNotificationManager.removeNotification(id: Todo.name!+Todo.desc!)
            }
            self.initDatas()
            self.collectionView.reloadData()
            self.deleteTodoList.removeAllObjects()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }

}
