//
//  CalendarViewController.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/22.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController
, UITableViewDelegate
, UITableViewDataSource
, FSCalendarDataSource
, FSCalendarDelegate
, FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var DayOfWeekLb: ScaledLabel!
    @IBOutlet weak var monthLb: ScaledLabel!
    @IBOutlet weak var dayLb: ScaledLabel!
    @IBOutlet weak var yearLb: ScaledLabel!
    
    let cellIdentifier = "calendarTableViewCell"
    private var todoItems:[Todo] = []
    private var selectedTodoItems:[Todo] = []


    fileprivate var lunar: Bool = false {
        didSet {
            self.calendarView.reloadData()
        }
    }
    fileprivate let lunarFormatter = LunarFormatter()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    var datesWithMultipleEvents:[String]?

    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.alwaysBounceVertical = false
        
        tableView.register(UINib(nibName: "calendarTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.allowsSelection = false

        self.addView.layer.cornerRadius = 35
        self.addView.layer.masksToBounds = false
        self.addView.layer.shadowRadius = 4
        self.addView.layer.shadowOpacity = 1
        self.addView.layer.shadowColor = UIColor.gray.cgColor
        self.addView.layer.shadowOffset = CGSize(width: 0 , height:2)
        tableView.allowsSelection = true
        
        initDatas()
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeight.constant = 400
        }
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        self.calendarView.select(Date())
        self.calendarView.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]

        // For UITest
        self.calendarView.accessibilityIdentifier = "calendar"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        initDatas()
    }
    
    func initDatas() {
        todoItems = DatabaseManager.getTodoDatas(completed: false)
        datesWithMultipleEvents = []
        for i in 0 ..< todoItems.count {
            let todoItem = todoItems[i]
            datesWithMultipleEvents?.append(self.dateFormatter2.string(from: todoItem.alertTime!))
        }
        tableView.reloadData()
    }
    
    func serchTodoData(date: Date) {
        selectedTodoItems.removeAll()
        let dateString = self.dateFormatter2.string(from: date)
        for i in 0 ..< todoItems.count {
            let todoItem = todoItems[i]
            if self.dateFormatter2.string(from: todoItem.alertTime!) == dateString {
                selectedTodoItems.append(todoItem)
            }
        }
        tableView.reloadData()
    }

    // MARK:- FSCalendarDataSource
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return self.gregorian.isDateInToday(date) ? "今日" : nil
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        guard self.lunar else {
            return nil
        }
        return self.lunarFormatter.string(from: date)
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "9999/10/30")!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var dayComponent    = DateComponents()
        dayComponent.day    = 1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: date)

        let dateString = self.dateFormatter2.string(from: nextDate!)
        var eventNum = 0
        for i in 0 ..< todoItems.count {
            let todoItem = todoItems[i]
            if self.dateFormatter2.string(from: todoItem.alertTime!) == dateString {
                eventNum += 1
            }
        }
        if eventNum > 3 {
            return 3
        }
        return eventNum
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        var dayComponent    = DateComponents()
        dayComponent.day    = 1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: date)

        let dateString = self.dateFormatter2.string(from: nextDate!)
        var eventColors: [UIColor] = []
        for i in 0 ..< todoItems.count {
            let todoItem = todoItems[i]
            if self.dateFormatter2.string(from: todoItem.alertTime!) == dateString {
                eventColors.append(UIColor(hexString: todoItem.bgColor!)!)
            }
        }
        if eventColors.count > 0 {
            return eventColors
        }
        return nil
    }

    // MARK:- FSCalendarDelegate

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        var dayComponent    = DateComponents()
        dayComponent.day    = 1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: date)

        serchTodoData(date: nextDate!)
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selectedTodoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarTableViewCell", for: indexPath) as! calendarTableViewCell
        cell.initData(todoData: selectedTodoItems[indexPath.row], ind: indexPath.row)
//        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddTodoViewController()
        vc.editType = "edit"
        vc.todo = todoItems[indexPath.row]
         print(todoItems[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        let vc = AddTodoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
