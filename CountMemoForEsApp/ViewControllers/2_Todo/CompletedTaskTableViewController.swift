
import UIKit
import XLPagerTabStrip

@objc protocol TodoCompletedTableViewControllerDelegate {
    func todoCompleted()
}

class CompletedTaskTableViewController: UITableViewController,TodoItemComplitedViewCellDelegate, IndicatorInfoProvider {
    
    internal var itemInfo = IndicatorInfo(title: "View")
    internal var delegate: TodoCompletedTableViewControllerDelegate?

    let cellIdentifier = "TodoItemTableViewCell"
    
    private var tableData : NSMutableArray = NSMutableArray()
    private var todoItems:[Todo] = []
    private var groupkey:NSMutableArray!
    private var grouplist:NSMutableArray!
    private var deletelist:NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView.backgroundColor = Config.BASE
        tableView.register(UINib(nibName: "TodoItemTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.allowsSelection = false
        
        groupkey = NSMutableArray()
        grouplist = NSMutableArray()
        deletelist = NSMutableArray()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initDatas()
    }
    
    internal func initDatas() {
        todoItems = DatabaseManager.getTodoDatas(completed: true)
        groupkey?.removeAllObjects()
        grouplist?.removeAllObjects()
        for i in 0 ..< todoItems.count{
            if(groupkey != nil){
                if(!groupkey.contains(todoItems[i].alertTime?.month as Any)){
                    groupkey?.add(todoItems[i].alertTime?.month as Any)
                }else{
                    continue
                }
            }
        }
        if(groupkey != nil){
            for i in 0 ..< groupkey.count{
                var todoInSectionDatas:[Todo] = []
                for j in 0 ..< todoItems.count{
                    if(groupkey.object(at: i) as! Int) == todoItems[j].alertTime?.month{
                        todoInSectionDatas.append(todoItems[j])
                    }
                }
                todoInSectionDatas.sort(){$0.alertTime! < $1.alertTime!}
                grouplist.add(todoInSectionDatas)
            }
        }
        self.tableView.reloadData()
        if todoItems.count >= 1{
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "todoq"))
        }else{
           self.tableView.backgroundView = UIImageView(image: UIImage(named: "todo"))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupkey.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 10,y: 0 , width: 500, height: 40 ))
        returnedView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 10,y: 0 , width: 500, height: 30 ))
        let title = self.groupkey[section]
        label.text = "\(title)月"
        returnedView.addSubview(label)
        return returnedView
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let todoInSectionDatas = self.grouplist.object(at: section) as! [Todo]
        return todoInSectionDatas.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemTableViewCell", for: indexPath) as! TodoItemTableViewCell
        var tododatas = self.grouplist.object(at: indexPath.section) as! [Todo]
        self.deletelist.contains(tododatas[indexPath.row])
        cell.initData(todoData: tododatas[indexPath.row], section: indexPath.section, ind: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func deleteCompleted(section: Int, ind: Int) {
        var tododatas = self.grouplist.object(at: section) as! [Todo]
        
        DatabaseManager.persistentContainer.viewContext.delete(tododatas[ind])
        LocalNotificationManager.removeNotification(id: tododatas[ind].name!+tododatas[ind].desc!)

        tododatas.remove(at: ind)
        
        self.grouplist.replaceObject(at: section, with: tododatas)
        let alert: UIAlertController = UIAlertController(title: "削除", message: "削除してもよろしいですか？\n（１度削除したデータは復元できません。）", preferredStyle:  UIAlertController.Style.actionSheet)
        let defaultAction: UIAlertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            for i in 0 ..< self.deletelist.count {
               let Todo = self.deletelist.object(at: i) as! Todo
                
                DatabaseManager.persistentContainer.viewContext.delete(Todo)
                LocalNotificationManager.removeNotification(id: Todo.name!+Todo.desc!)
            }
            self.tableView.reloadData()
            self.initDatas()
            self.deletelist.removeAllObjects()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func checkBtnClicked(section: Int, ind: Int) {
        let tododatas = self.grouplist.object(at: section) as! [Todo]
        let selectedTodo = tododatas[ind]
        selectedTodo.completedAt = Date()
        selectedTodo.completedFlag = false
        // 上で作成したデータをデータベースに保存
        let alert: UIAlertController = UIAlertController(title: "確認", message: "完了したタスクを未完了タスクに戻しますか?", preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            DatabaseManager.saveContext()
            self.delegate?.todoCompleted()
            self.initDatas()
            self.tableView.reloadData()
            self.deletelist.removeAllObjects()
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
