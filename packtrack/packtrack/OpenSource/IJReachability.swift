//
//  IJReachability.swift
//  packtrack
//
//  Created by ksymac on 2017/10/01.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import Foundation
import AFNetworking
class IJReachability: NSObject {
    
    static var isReachability = true
    class func isConnectedToNetwork() -> Bool {
        return isReachability
    }
    
    class func startMonitoring(){
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange {
            (status :AFNetworkReachabilityStatus) in
            if(status.rawValue == 0){
                isReachability = false
            }else{
                isReachability = true
            }
        }
    }
}
