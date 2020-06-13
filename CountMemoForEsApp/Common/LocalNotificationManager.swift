//
//  LocalNotificationManager.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/22.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class LocalNotificationManager: NSObject {

    static func addNotificaion(title: String, id: String, time: TimeInterval) {
        if time <= 0 {
            return
        }
        let delegateObj = AppDelegate.instance();
        // Notification のインスタンス作成
        let content = UNMutableNotificationContent() // Содержимое уведомления

        let categoryIdentifire = "Delete Notification Type"
        
        // タイトル、本文の設定
        let titleText = title
        content.title = "\(String(describing: titleText))"
        content.body = "エントリーシートの締め切りが迫っています。"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire

        let oneDayTime = time - 86400
        print("one day time: \(oneDayTime)")
        if oneDayTime > 0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time-86400, repeats: false)
            //リクエストの設定
            let request = UNNotificationRequest.init(identifier: id, content: content, trigger: trigger)
            //通知
            delegateObj.notificationCenter.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
        
        let threeDayTime = time-86400*3
        print("threeDayTime \(threeDayTime)")
        if threeDayTime>0{
            let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: time-86400*3, repeats: false)
            //リクエストの設定
            let request1 = UNNotificationRequest.init(identifier: id, content: content, trigger: trigger1)
            //通知
            delegateObj.notificationCenter.add(request1) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
                
        }
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifire,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        delegateObj.notificationCenter.setNotificationCategories([category])
    }
    
    static func removeNotification(id: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
        center.removeDeliveredNotifications(withIdentifiers: [id])
    }
}
