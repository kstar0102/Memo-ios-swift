
import UIKit
import SVProgressHUD
import CCBottomRefreshControl
import PullToRefreshKit

class MemoListViewController: UIViewController
, UICollectionViewDelegate
, UICollectionViewDataSource
, UICollectionViewDelegateFlowLayout
, UISearchBarDelegate
, UISearchDisplayDelegate
, MemoCollectionViewCellDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBtnView: UIView!
    
    
    @IBOutlet weak var colorback: UIImageView!
    @IBOutlet weak var addImage: UIImageView!
    private var gPopupMaskBG: UIView?
    private var delegateObj: AppDelegate?
    private var loadingFlag: Bool = false
    private var updateFlag: Bool = false
    private var editable: Bool = false
    
    private var groupedMemoList: NSMutableArray!
    private var groupKeyList: NSMutableArray!
    private var deleteMemoList: NSMutableArray!

    override func viewDidLoad() {
        super.viewDidLoad()

//        SVProgressHUD.show()
        self.navigationController?.isNavigationBarHidden = true

        searchBar.delegate = self
        self.collectionView.register(UINib(nibName: "MemoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MemoCollectionViewCell")
        self.collectionView.register(UINib(nibName: "MemoHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MemoHeaderCollectionReusableView");
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.addBtnView.layer.cornerRadius = 35
        self.addBtnView.layer.masksToBounds = false
        self.addBtnView.layer.shadowRadius = 4
        self.addBtnView.layer.shadowOpacity = 1
        self.addBtnView.layer.shadowColor = UIColor.gray.cgColor
        self.addBtnView.layer.shadowOffset = CGSize(width: 0 , height:2)
        self.collectionView.backgroundColor = .white
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: Config.SCREEN_WIDTH/2-15, height: (Config.SCREEN_WIDTH/2-15)*1.3)
        layout.headerReferenceSize = CGSize(width:0, height:40)
        layout.sectionHeadersPinToVisibleBounds = true

//        let bottomRefreshController = UIRefreshControl()
//        bottomRefreshController.triggerVerticalOffset = 20
//        bottomRefreshController.addTarget(self, action: #selector(refreshBottom), for: .valueChanged)
//
//        collectionView.bottomRefreshControl = bottomRefreshController
        
        deleteMemoList = NSMutableArray()
        groupedMemoList = NSMutableArray()
        groupKeyList = NSMutableArray()
        addDoneButtonOnKeyboard()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.loadMemoData(key: self.searchBar.searchTextField.text!)
    }
    
    func loadMemoData(key: String) {
        var memoData:[Memo] = []
        memoData = DatabaseManager.getSearchDatas(keyword: key)
        groupedMemoList.removeAllObjects()
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
            groupedMemoList.add(memoItems)
        }
        self.collectionView.reloadData()
        
        if (memoData.count < 1){
            self.collectionView.backgroundView = UIImageView(image: UIImage(named: "memoback"))
        }else{
           self.collectionView.backgroundView = UIImageView(image: UIImage(named: "backgoround1"))
        }

    }

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.searchBar.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        self.searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String) {
        self.loadMemoData(key: searchText)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let memoDatas = self.groupedMemoList.object(at: section) as! [Memo]
        return memoDatas.count;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MemoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoCollectionViewCell", for: indexPath) as! MemoCollectionViewCell;
        let memoDatas = self.groupedMemoList.object(at: indexPath.section) as! [Memo]
        var selected = false
        if deleteMemoList.contains(memoDatas[indexPath.row]) {
            selected = true
        }
        cell.initData(memoData: memoDatas[indexPath.row], section: indexPath.section, ind: indexPath.row, editable: selected)
        cell.delegate = self
        
        return cell;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.groupKeyList.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MemoViewController()
        vc.editType = "edit"
        let memoDatas = self.groupedMemoList.object(at: indexPath.section) as! [Memo]
        vc.memo = memoDatas[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MemoHeaderCollectionReusableView", for: indexPath) as! MemoHeaderCollectionReusableView

            reusableview.initData(markNum: indexPath.section+1, groupTitle: (self.groupKeyList[indexPath.section] as! String))
            return reusableview
        default:  fatalError("Unexpected element kind")
        }
    }
    
    func checkBtnClicked(section: Int, ind: Int, selected: Bool) {
        let memoDatas = self.groupedMemoList.object(at: section) as! [Memo]
        if selected {
            deleteMemoList.add(memoDatas[ind])
        }else {
            deleteMemoList.remove(memoDatas[ind])
        }
        if deleteMemoList.count > 0 {
            self.editable = true
            self.addBtnView.backgroundColor = UIColor(hexString: "F9764D")
            if #available(iOS 13.0, *) {
                self.addImage.image = UIImage(systemName: "bin.xmark")
            } else {
                // Fallback on earlier versions
            }
        }else {
            self.editable = false
            self.addBtnView.backgroundColor = UIColor(hexString: "30C4A4")
            if #available(iOS 13.0, *) {
                self.addImage.image = UIImage(systemName: "plus")
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func deleteSelectedDatas() {
        let alert: UIAlertController = UIAlertController(title: "注意", message: "削除してもよろしいですか？\n（１度削除したデータは復元できません。）", preferredStyle:  UIAlertController.Style.actionSheet)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            for i in 0 ..< self.deleteMemoList.count {
               let memo = self.deleteMemoList.object(at: i) as! Memo
                DatabaseManager.persistentContainer.viewContext.delete(memo)
                LocalNotificationManager.removeNotification(id: memo.company!+memo.title!)
            }
            self.editable = false
            self.loadMemoData(key: self.searchBar.searchTextField.text!)
            self.collectionView.reloadData()
            self.deleteMemoList.removeAllObjects()
            self.addBtnView.backgroundColor = UIColor(hexString: "30C4A4")
            if #available(iOS 13.0, *) {
                self.addImage.image = UIImage(systemName: "plus")
            } else {
                // Fallback on earlier versions
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func addBtnClicked(_ sender: Any) {
        if !self.editable {
            let vc = NewESViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            self.tabBarController?.tabBar.isHidden = true
        }else {
            if self.deleteMemoList.count > 0 {
                deleteSelectedDatas()
            }
        }
    }
    
}
