//
//  MemoModel.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/21.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class MemoModel: NSObject, NSCoding {

    var company     : String = ""
    var memoDate     : String = ""
    var memoNum     : String = ""
    var memoContent     : String = ""
    var memoTitle     : String = ""
    var alertDate : Double = 0
    var createdDate : Double = 0

    var json            : NSDictionary = NSDictionary()

    override init() {
        
    }

    convenience init(_ json: NSDictionary){
        self.init()
        self.initWithJSON(json: json)
    }

    func initWithJSON(json:NSDictionary){
        self.json = json
        if let val = json["company"]{
            company = (val as? String) ?? ""
        }
        if let val = json["memo_date"]{
            memoDate = (val as? String) ?? ""
        }
        if let val = json["memo_num"]{
            memoNum = (val as? String) ?? ""
        }
        if let val = json["memo_content"]{
            memoContent = (val as? String) ?? ""
        }
        if let val = json["memo_title"]{
            memoTitle = (val as? String) ?? ""
        }
        if let val = json["alert_date"]{
            alertDate = (val as? Double) ?? 0
        }
        if let val = json["created_date"]{
            createdDate = (val as? Double) ?? 0
        }
    }

    func encode(with aCoder: NSCoder) {
        let newDic = self.json.mutableCopy() as! NSMutableDictionary
        newDic.setValue(self.company, forKey: "company")
        newDic.setValue(self.memoTitle, forKey: "memo_title")
        newDic.setValue(self.memoDate, forKey: "memo_date")
        newDic.setValue(self.memoNum, forKey: "memo_num")
        newDic.setValue(self.memoContent, forKey: "memo_content")
        newDic.setValue(self.alertDate, forKey: "alert_date")
        newDic.setValue(self.createdDate, forKey: "created_date")
        aCoder.encode(newDic, forKey: "json")
    }

    required convenience init?(coder decoder:NSCoder) {
        self.init()
        let json = decoder.decodeObject(forKey: "json") as! NSDictionary
        self.initWithJSON(json: json)
    }

}
