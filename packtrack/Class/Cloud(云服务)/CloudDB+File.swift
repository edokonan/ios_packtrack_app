//
//  ViewController.swift
//  packtrack
//
//  Created by ksymac on 2017/11/25.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import Firebase

class BackupModel : Codable{
    var mainModel : Array<TrackMain> = []
    var detailModel : Array<TrackDetail> = []
    var statusModel : Array<TrackStatus> = []
}

extension CloudDBRef {
    //生成文件名
    func createFileNameWithDate()->String{
        let formater = DateFormatter()
        formater.dateFormat = File_Name_Format
        let dateStr = formater.string(from: Date())
        return dateStr
    }

    // MARK:- 根据DB的数据生成Json文件
    func createJsonFileWithDB() -> URL?{
//        let trackMainModel = TrackMainModel.shared//model
//        let trackDetailModel = TrackDetailModel()//model
//        let trackStatusModel = TrackStatusModel()//model
        let bakupmodel = BackupModel()
//        bakupmodel.mainModel = trackMainModel.getAll()
//        bakupmodel.detailModel = trackDetailModel.getAll()
//        bakupmodel.statusModel = trackStatusModel.getSection2List()
        bakupmodel.statusModel = IceCreamMng.shared.getSection2List()
        bakupmodel.mainModel = IceCreamMng.shared.getAllMainBeansByStatus(ComFunc.TrackList_all)
        bakupmodel.detailModel = IceCreamMng.shared.getAllDetails()
        // Encode
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(bakupmodel)
        if let json = String(data: jsonData, encoding: String.Encoding.utf8){
           return writeToJsonFile(text: json)
        }
        return nil
    }
    func writeToJsonFile(text:String, filename: String = "file.Json") -> URL?{
        // let text = "some text" //just a text
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filename)
            print(fileURL)
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                readDataFromJsonFile(fileURL: fileURL)
                return fileURL
            }
            catch {/* error handling here */
                
            }
            return fileURL
        }
        return nil
    }
    // MARK:- 将下载的数据写入到临时文件
    func  writeDataToFile() -> Bool {
        return true
    }
    func restoreDataFromCloudData(data: Data,
                    successCompetion: (()->())?,
                    failureCompetion: (()->())?) -> Bool{
        
        var ret = false
        do {
            //测试目标，将文件保存到本地
            if let temptxt = String.init(data: data as Data, encoding: .utf8),
               let fileurl = writeToJsonFile(text: temptxt, filename:"download.json"){
                print(fileurl)
            }
            let decoder = JSONDecoder()
            if let retData : BackupModel = try? decoder.decode(BackupModel.self, from: data){
                ret = saveRealmDbWithData(data: retData)
            }
            //不需要转换
            //let text2 = String.init(data: data as Data, encoding: .utf8)
            //let jsonData = text2?.data(using: .utf8, allowLossyConversion: true)
            //if let retData : BackupModel = try? decoder.decode(BackupModel.self, from: jsonData!){
            //return retData
            //}
        }catch {
            
        }
        if ret {
            if let block = successCompetion{
                block()}
        }else{
            if let block = failureCompetion{
                block()}
        }
        return ret
    }
    func saveSqliteDbWithData(data : BackupModel) -> Bool{
        let trackMainModel = TrackMainModel.shared//model
        let trackDetailModel = TrackDetailModel.shared//model
        let trackStatusModel = TrackStatusModel.shared//model
        if data.statusModel.count > 0 {
            trackStatusModel.retoreData(datas: data.statusModel)
        }
        if data.mainModel.count > 0 {
            trackMainModel.retoreData(datas: data.mainModel,trackdetail: trackDetailModel )
        }
        if data.detailModel.count > 0 {
            trackDetailModel.retoreData(datas: data.detailModel)
        }
        return true
    }
    func saveRealmDbWithData(data : BackupModel) -> Bool{
        DispatchQueue.main.sync{
//        DispatchQueue(label: "com.example.myApp.bg").sync {
            if data.statusModel.count > 0 {
                IceCreamMng.shared.restoreStatusDataWithCloudFile(datas: data.statusModel)
            }
            if data.mainModel.count > 0 {
                IceCreamMng.shared.restoreMainDataWithCloudFile(datas: data.mainModel)
            }
            if data.detailModel.count > 0 {
                IceCreamMng.shared.restoreDetailDataWithCloudFile(datas:  data.detailModel)
            }
        }
        return true
    }
    
    
    
    //从Json文件读取数据，并解析
    func readDataFromJsonFile(fileURL: URL) -> BackupModel?{
        do {
            let text2 = try String(contentsOf: fileURL, encoding: .utf8)
            //let jsonData = jsonString.data(encoding: .utf8)!
            let jsonData = text2.data(using: .utf8, allowLossyConversion: true)
            let decoder = JSONDecoder()
            
            if let retData : BackupModel = try? decoder.decode(BackupModel.self, from: jsonData!){
                //                print(beer.)
                return retData
            }
        }catch {
            
        }
        return nil
    }
    //
    func loadData() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentDirectory = paths[0] as! String
        let path = documentDirectory.appending("myData.plist")
        let fileManager = FileManager.default
        if(!fileManager.fileExists(atPath: path)){
            if let bundlePath = Bundle.main.path(forResource: "myData", ofType: "plist"){
                let result = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle file myData.plist is -> \(result?.description)")
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                }catch{
                    print("copy failure.")
                }
            }else{
                print("file myData.plist not found.")
            }
        }else{
            print("file myData.plist already exits at path.")
        }
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("load myData.plist is ->\(resultDictionary?.description)")
        
//        let myDict = NSDictionary(contentsOfFile: path)
//        if let dict = myDict{
//            myItemValue = dict.object(forKey: myItemKey) as! String?
//            txtValue.text = myItemValue
//        }else{
//            print("load failure.")
//        }
    }
    func clearDB() -> Bool{
//        let trackMainModel = TrackMainModel.shared//model
//        let trackDetailModel = TrackDetailModel.shared//model
//        let trackStatusModel = TrackStatusModel.shared//model
//
//        trackStatusModel.clearDB()
//        trackDetailModel.clearDB()
//        trackMainModel.clearDB()
        
        IceCreamMng.shared.clearDB()
        return true
    }
}
