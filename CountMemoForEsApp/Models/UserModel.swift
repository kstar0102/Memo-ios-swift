//
//  UserModel.swift
//  IOSChattingApp
//
//  Created by ADV on 2019/10/02.
//  Copyright © 2019 ADV. All rights reserved.
//

import UIKit

class UserModel: NSObject, NSCoding {
    
    var userName     : String = ""
    var email        : String = ""
    var password     : String = ""
    var avata        : String = ""
    var memoType     : Int = 0

    var json            : NSDictionary = NSDictionary()

    //---------------------------------------------------------------------------------------------------------
    //                                      Init
    //---------------------------------------------------------------------------------------------------------
    override init() {
        
    }
    //---------------------------------------------------------------------------------------------------------
    //                                      Init With JSON
    //---------------------------------------------------------------------------------------------------------
    convenience init(_ json: NSDictionary){
        self.init()
        self.initWithJSON(json: json)
    }
    
    func initWithJSON(json:NSDictionary){
        self.json = json
        if let val = json["user_name"]{
            userName = (val as? String) ?? ""
        }
        if let val = json["email"]{
            email = (val as? String) ?? ""
        }
        if let val = json["avata"]{
            avata = (val as? String) ?? ""
        }
        if let val = json["password"]{
            password = (val as? String) ?? ""
        }
        if let val = json["memo_type"]{
            memoType = (val as? Int) ?? 0
        }
    }
    //---------------------------------------------------------------------------------------------------------
    //                                      Encode With Coder
    //---------------------------------------------------------------------------------------------------------
    func encode(with aCoder: NSCoder) {
        let newDic = self.json.mutableCopy() as! NSMutableDictionary
        newDic.setValue(self.userName, forKey: "user_name")
        newDic.setValue(self.email, forKey: "email")
        newDic.setValue(self.avata, forKey: "avata")
        newDic.setValue(self.password, forKey: "password")
        newDic.setValue(self.memoType, forKey: "memo_type")
        aCoder.encode(newDic, forKey: "json")
    }
    //---------------------------------------------------------------------------------------------------------
    //                                      Decode With Coder
    //---------------------------------------------------------------------------------------------------------
    required convenience init?(coder decoder:NSCoder) {
        self.init()
        let json = decoder.decodeObject(forKey: "json") as! NSDictionary
        self.initWithJSON(json: json)
    }
    
    func getDictionaryData() -> NSMutableDictionary  {
        let newDic = self.json.mutableCopy() as! NSMutableDictionary
        newDic.setValue(self.userName, forKey: "user_name")
        newDic.setValue(self.email, forKey: "email")
        newDic.setValue(self.avata, forKey: "avata")
        newDic.setValue(self.password, forKey: "password")
        newDic.setValue(self.memoType, forKey: "memo_type")
        return newDic
    }
}
