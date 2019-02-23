//
//  UnitDate.swift
//  packtrack
//
//  Created by ksymac on 2017/12/02.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit

class DateUtils {
    class func dateFromString(string: String, format: String) -> NSDate? {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = format
        return formatter.date(from: string) as? NSDate
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
//        formatter.calendar = NSGregorianCalendar
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
    
    //当前的年不显示
    class func StrFormateWithYear(instr: String)->String{
        let date = Date()
        let calendar = Calendar.current
        var year = calendar.component(.year, from: date)
        
        guard let data1 = DateUtils.dateFromString(string: instr, format: "YYYY/MM/dd HH:mm:ss")  else{
            return ""
        }
        var year1 = calendar.component(.year, from: data1 as Date)
        if year == year1 {
            let str = DateUtils.stringFromDate(date: data1, format: "MM/dd HH:mm")
            return str
        }else{
            let str = DateUtils.stringFromDate(date: data1, format: "YYYY/MM/dd HH:mm")
            return str
        }
    }
}
