//
//  LoginController+handlers.swift
//  gameofchats
//
//  Created by Brian Voong on 7/4/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: 注册用户
    func handleRegister() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {
            SVProgressHUD.showError(withStatus: "Form is not valid")
            SVProgressHUD.dismiss(withDelay: 1)
            return
        }
        SVProgressHUD.show()

        Auth.auth().createUser(withEmail: email, password: password, completion: {
            (user: User?, error) in
            if let err = error {
                var errmsg = error?.localizedDescription
                if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                    switch errCode {
                    case .invalidEmail:
                        errmsg = "invalid email"
                    case .emailAlreadyInUse:
                        errmsg = "in use"
                    default:
                        errmsg = "Other error!"
                    }
                }
                SVProgressHUD.showError(withStatus: errmsg)
                SVProgressHUD.dismiss(withDelay: 3)
                return
            }
            guard let uid = user?.uid else {
                SVProgressHUD.showError(withStatus:"失敗した")
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
            let values = ["name": name, "email": email, "version": 1,] as [String : AnyObject]
            self.registerUserIntoDatabaseWithUID(uid, values: values)
            //不上传头像，所以下面都关闭
//            let imageName = UUID().uuidString
//            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
//            if let profileImage = self.profileImageView.image,
//                let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
//                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
//                    if error != nil {
//                        print(error!)
//                        return
//                    }
//                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
//                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
//                    }
//                })
//            }else{
//                let values = ["name": name, "email": email, "profileImageUrl": ""]
//                self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
//            }
        })
    }
    //更新USER的数据
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child(CloudDB_UserTable).child(uid)
        
        weak var weak_self = self
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
//                print(err!)
                SVProgressHUD.showError(withStatus: err?.localizedDescription)
                SVProgressHUD.dismiss(withDelay: 1)
                return
            }
//            let user = User(dictionary: values)
//            self.messagesController?.setupNavBarWithUser(user)
            SVProgressHUD.dismiss()
            weak_self?.dismiss(animated: true)
            if let block = weak_self?.successCompletionHandle{
                block()
            }
        })
    }
    
    //MARK: 处理遗忘密码
    func handleForgotPassword() {
        guard let email = emailTextField.text else {
            SVProgressHUD.showError(withStatus: "Form is not valid")
            SVProgressHUD.dismiss(withDelay: 1)
            return
        }
        SVProgressHUD.show()
        weak var weak_self = self
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let err = error {
                var errmsg = error?.localizedDescription
                SVProgressHUD.showError(withStatus: errmsg)
                SVProgressHUD.dismiss(withDelay: 3)
                return
            }else{
                self.forgotPasswordButton.isHidden = true
//                forgotPasswordButton.setTitleColor(UIColor.withAlphaComponent(0.5), for: UIControlState())
                SVProgressHUD.showInfo(withStatus: "パスワードリセットメールを送信しました。")
                SVProgressHUD.dismiss(withDelay: 3)
            }
        }
    }
    
    //MARK: 处理登录
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            SVProgressHUD.showError(withStatus: "Form is not valid")
            SVProgressHUD.dismiss(withDelay: 1)
            return
        }
        SVProgressHUD.show()
        weak var weak_self = self
        Auth.auth().signIn(withEmail: email, password: password, completion: {
            (user, error ) in
            if let err = error {
                var errmsg = error?.localizedDescription
                if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                    switch errCode {
                    case .wrongPassword:// 17009:
                        errmsg = "パスワードが間違っている"
                    case .userNotFound:// 17011: ユーザが存在しない
                        errmsg = "ユーザが存在しない"
                    default:
                        errmsg = "Other error!"
                    }
                }
                SVProgressHUD.showError(withStatus: errmsg)
                SVProgressHUD.dismiss(withDelay: 3)
                return
            }
            SVProgressHUD.dismiss()
            if let uid = user?.uid  {
                weak_self?.dismiss(animated: true)
                if let block = weak_self?.successCompletionHandle{
                    block()
                }
            }
        })
    }
    
    //更新用户的头像
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}
