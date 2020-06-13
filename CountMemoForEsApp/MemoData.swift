////
////  MemoData.swift
////  CountMemoForEsApp
////
////  Copyright © 2019年 Yoko Ishikawa. All rights reserved.
////
//
//import Foundation
//
//class MemoData:NSObject, NSSecureCoding {
//    
//    static var supportsSecureCoding: Bool{
//        return true
//    }
//    
//    var title:String?
//    var company:String?
//    var memoText:String?
//    var memoNum:Int?
//    var memoDate:String?
//
//    override init() {
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(title, forKey: "titleName")
//        aCoder.encode(company, forKey: "companyName")
//        aCoder.encode(memoText, forKey: "textName")
//        aCoder.encode(memoNum, forKey: "memoNum")
//        aCoder.encode(memoDate, forKey: "dateName")
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        title = aDecoder.decodeObject(forKey: "titleName") as? String
//        company = aDecoder.decodeObject(forKey: "companyName") as? String
//        memoText = aDecoder.decodeObject(forKey: "textName") as? String
//        memoNum = aDecoder.decodeObject(forKey: "memoNum") as? Int
//        memoDate = aDecoder.decodeObject(forKey: "dateName") as? String
//    }
//}

