//
//  AppDelegate.swift
//  packtrack
//
//  Created by ZHUKUI on 2015/08/05.
//  Copyright (c) 2015年 ZHUKUI. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
//import FirebaseCrash
//import iRate
import UserNotifications
import IceCream
import CloudKit

extension AppDelegate{
    func setMsg(_ application: UIApplication){
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
                    self.checkRegisteredForRemoteNotifications()
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        // [END register_for_notifications]
    }
    

    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        if let dict = userInfo as? [String: NSObject]{
            // Print full message.
            print(dict)
            let notification = CKNotification(fromRemoteNotificationDictionary: dict)
            
            if (notification.subscriptionID == IceCreamConstant.cloudKitSubscriptionID) {
                NotificationCenter.default.post(name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil, userInfo: userInfo)
            }
        }
        completionHandler(.newData)
    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        let dict = userInfo as! [String: NSObject]
//        let notification = CKNotification(fromRemoteNotificationDictionary: dict)
//
//        if (notification.subscriptionID == IceCreamConstant.cloudKitSubscriptionID) {
//            NotificationCenter.default.post(name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil, userInfo: userInfo)
//        }
//        completionHandler(.newData)
//    }
    
    
    
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        if let trackno = userInfo["trackno"], let tracktype = userInfo["tracktype"] {
            print("\(trackno) \(tracktype)")
            if let mainvc = mainViewController{
                tabBarController?.selectedIndex = 0
                mainvc.movetoDetailViewWithClickNotification(trackNo: trackno as! String )
                gcmClickTrackNo = nil
            }else{
                gcmClickTrackNo = trackno as! String
            }
        }
        // Change this to your preferred presentation option
        completionHandler([])
    }
    //通过通知点击打开窗口
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        tabBarController?.selectedIndex = 0
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        if let trackno = userInfo["trackno"], let tracktype = userInfo["tracktype"] {
            print("\(trackno) \(tracktype)")
            if let mainvc = mainViewController{
                mainvc.movetoDetailViewWithClickNotification(trackNo: trackno as! String )
                gcmClickTrackNo = nil
            }else{
                gcmClickTrackNo = trackno as! String
            }
        }
        // Print full message.
        print(userInfo)
        completionHandler()
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        //PringManager.shared.createUser(name: "",device: fcmToken)
        checkRegisteredForRemoteNotifications()
        fcmtoken = fcmToken
    }
    func checkRegisteredForRemoteNotifications(){
        let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if isRegisteredForRemoteNotifications {
            // User is registered for notification
            print("User is registered for notification")
        } else {
            // Show alert user is not registered for notification
            print("User is not registered for notification")
        }
        if enableRemoteNotification != isRegisteredForRemoteNotifications{
            enableRemoteNotification=isRegisteredForRemoteNotifications
        }
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}


