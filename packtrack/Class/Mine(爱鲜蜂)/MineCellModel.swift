//
//  ViewController.swift
//  packtrack
//
//  Created by ksymac on 2017/11/25.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//
import Foundation

class MineCellModel: NSObject {
    
    var title: String?
    var attrTitle: NSMutableAttributedString?
    var iconName: String?
    var complete: (()->())?
    
    class func loadMineCellModels() -> [MineCellModel] {
        var mines = [MineCellModel]()
        let path = Bundle.main.path(forResource: "MinePlist", ofType: "plist")
        let arr = NSArray(contentsOfFile: path!)
        
        for dic in arr! {
            mines.append(MineCellModel.mineModel(dic as! NSDictionary))
        }
        
        return mines
    }
    class func mineModel(_ dic: NSDictionary) -> MineCellModel {
        let model = MineCellModel()
        model.title = dic["title"] as? String
        model.iconName = dic["iconName"] as? String
        return model
    }
    
    convenience init(title:String, iconName:String,complete:@escaping (()->())) {
        self.init()
        self.title = title
        self.iconName = iconName
        self.complete = complete
    }
//    override init() {
//        super.init()
//    }
    
}

