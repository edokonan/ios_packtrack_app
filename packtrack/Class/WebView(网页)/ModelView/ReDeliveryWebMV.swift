//
//  ReDeliveryWebModelView.swift
//  packtrack
//
//  Created by ksymac on 2017/03/29.
//  Copyright © 2017 ZHUKUI. All rights reserved.
//

import Foundation



let yamato_login_url = "https://smp-cmypage.kuronekoyamato.co.jp/smp_portal/s/loginpage"
let yamato_input_trackno = "https://syuhai.kuronekoyamato.co.jp/saihai/SRMENU"
//let autoinput_yamato_login = "document.getElementById( 'kuroneko_id' ).value = 'zhukui';document.getElementById( 'kuroneko_pass' ).value = 'zhukui123';"
let autoinput_yamato_login = "document.getElementById( 'kuroneko_id' ).value = '%@';document.getElementById( 'kuroneko_pass' ).value = '%@';"
let autoinput_yamato_trackno = "document.getElementById( 'denp' ).value = '%@';"
let key_yamato_account="key_yamato_account"
let key_yamato_account_id="key_yamato_account_id"
let key_yamato_account_pass="key_yamato_account_pass"



/// login page
let sagawa_login_url = "https://www.e-service.sagawa-exp.co.jp//portal/do/login/show"
/// input track no page
let sagawa_input_trackno = "https://www.e-service.sagawa-exp.co.jp/e/f.d"

let autoinput_sagawa_login = "document.getElementsByName( 'user' )[0].value = '%@';document.getElementsByName( 'pass' )[0].value = '%@';"
let autoinput_sagawa_trackno = "document.getElementsByName( 'orderNumbers[0].formalNo' )[0].value = '%@';"
let key_sagawa_account="key_sagawa_account"
let key_sagawa_account_id="key_sagawa_account_id"
let key_sagawa_account_pass="key_sagawa_account_pass"

class ReDeliveyWebMV:NSObject{
    static let shared = ReDeliveyWebMV()
}
