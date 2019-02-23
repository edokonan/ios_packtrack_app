//
//  DatabaseRef.swift
//  packtrack
//
//  Created by ksymac on 2017/11/13.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import UIKit
import Firebase

var userinfo : User?
class CloudUser: NSObject {
    func login(){
        let email="zhukui83@gmail.com"
        let password="zhukui123"
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            if let err = error{
                print(err.localizedDescription)
            }
            if let use = user{
                userinfo = use
            }
        }
    }
    func register(){
        let email="zhukui83@gmail.com"
        let password="zhukui123"
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            if let err = error{
                print(err.localizedDescription)
            }
            if let use = user{
                userinfo = use
            }
        }
    }
}
