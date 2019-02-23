//
//  LoginController.swift
//  gameofchats
//
//  Created by Brian Voong on 6/24/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class LoginController: BaseViewController,UITextFieldDelegate{

    var messagesController: MessagesController?
    var successCompletionHandle:(() -> ())?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn before responder\n")
        textField.resignFirstResponder()
        print("textFieldShouldReturn\n")
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing\n")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing\n")
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing\n")
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        print("textFieldDidEndEditing\n")
    }
    
    
    @IBOutlet weak var inputsContainerView: UIView!
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithCustom(220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithCustom(220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let emailTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Email"
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        return tf
//    }()
//
//    let passwordTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Password"
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.isSecureTextEntry = true
//        return tf
//    }()
    
    @IBOutlet weak var loginRegisterSegmentedControl: UISegmentedControl!
    
//    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
//        let sc = UISegmentedControl(items: ["Login", "Register"])
//        sc.translatesAutoresizingMaskIntoConstraints = false
//        sc.tintColor = UIColor.white
//        sc.selectedSegmentIndex = 1
//        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
//        return sc
//    }()
//
//    lazy var : UIImageView = {
//        let imageView = UIImageView()
//        return imageView
//    }()
//    let nameTextField: UITextField = {
//        let tf = UITextField()
//        return tf
//    }()
//
    func setupUI(){
        inputsContainerView.backgroundColor = UIColor.white
        inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputsContainerView.layer.cornerRadius = 5
        inputsContainerView.layer.masksToBounds = true
        
        loginRegisterButton.backgroundColor = GlobalHeadColor //UIColor(r: 80, g: 101, b: 161)
        loginRegisterButton.setTitle("Register", for: UIControlState())
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterButton.setTitleColor(UIColor.white, for: UIControlState())
        loginRegisterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)

        forgotPasswordButton.backgroundColor = GlobalHeadColor //UIColor(r: 80, g: 101, b: 161)
        forgotPasswordButton.setTitle("Reset Password", for: UIControlState())
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.setTitleColor(UIColor.white, for: UIControlState())
        forgotPasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPasswordRegister), for: .touchUpInside)
        forgotPasswordButton.isHidden = true
        
        
        nameTextField.placeholder = " Name"
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.borderStyle = .none
//        nameTextField.iconFont = UIFont(name: "FontAwesome", size: 15)
//        nameTextField.iconText = "&#xf0f9"
        nameTextField.iconWidth = 12
       
        
        emailTextField.placeholder = " Email"
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.borderStyle = .none
        emailTextField.iconWidth = 12
        
        passwordTextField.placeholder = " Password"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.borderStyle = .none
        passwordTextField.isSecureTextEntry = true
//        passwordTextField.iconFont = UIFont(name: "FontAwesome", size: 15)
//        passwordTextField.iconText = "&#xf040;"
        passwordTextField.iconWidth = 12
        
        
        nameTextField.keyboardType = UIKeyboardType.default
        emailTextField.keyboardType = UIKeyboardType.default
        passwordTextField.keyboardType = UIKeyboardType.alphabet
//        if #available(iOS 10.0, *) {
//            emailTextField.keyboardType = UIKeyboardType.asciiCapableNumberPad
//            passwordTextField.keyboardType = UIKeyboardType.asciiCapableNumberPad
//        } else {
//            emailTextField.keyboardType = UIKeyboardType.alphabet
//            passwordTextField.keyboardType = UIKeyboardType.alphabet
//        }
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //设置头像
//        profileImageView.image = UIImage(named: "gameofthrones_splash")
//        profileImageView.image = UIImage(named: "v2_my_avatar")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
//        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImageView.isUserInteractionEnabled = true
        
        
//        let sc = UISegmentedControl(items: ["Login", "Register"])
        loginRegisterSegmentedControl.setTitle("Login", forSegmentAt: 0)
        loginRegisterSegmentedControl.setTitle("Register", forSegmentAt: 1)
        loginRegisterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterSegmentedControl.tintColor = UIColor.white
        loginRegisterSegmentedControl.selectedSegmentIndex = 1
        loginRegisterSegmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action:  #selector(closeMe))
        
        
//        emailTextField.placeholder = config.emailPlaceholder
//        emailTextField.errorColor = errorTintColor
//        passwordTextField.errorColor = errorTintColor
//        nameTextField.errorColor = errorTintColor
    }
//    public var tintColor = UIColor(red: 185.0 / 255.0, green: 117.0 / 255.0, blue: 216.0 / 255.0, alpha: 1)
//    public var errorTintColor = UIColor(red: 241 / 255, green: 196 / 255 , blue: 15 / 255, alpha: 1)
    // 收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = GlobalHeadColor
        
//        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
//        view.backgroundColor = UIColor(r: 80, g: 100, b: 220)
//        view.addSubview(inputsContainerView)
//        view.addSubview(loginRegisterButton)
//        view.addSubview(CloseButton)
//        view.addSubview(profileImageView)
//        view.addSubview(loginRegisterSegmentedControl)

        setupUI()
        setupProfileImageView()
        setupInputsContainerView()
        setupForgotPasswordButton()
        setupLoginRegisterButton()
//        setupCloseButton()
        setupLoginRegisterSegmentedControl()
        
        setupValidation()
        
        
        //设置初始画面
        loginRegisterSegmentedControl.selectedSegmentIndex = 0
        handleLoginRegisterChange()
    }
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            self.validateFields(isRigester: false) {
                handleLogin()
            }
        } else {
            self.validateFields(isRigester: true)  {
                handleRegister()
            }
        }
    }
    func handleForgotPasswordRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            self.validateFields_ForgotPassword() {
                handleForgotPassword()
            }
        } else {

        }
    }
    
    func closeMe() {
        self.dismiss(animated: true) {
        }
    }
    

    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControlState())
        
        // change height of inputContainerView, but how???
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        forgotPasswordButton.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 1
//        if (loginRegisterSegmentedControl.selectedSegmentIndex == 0){
//            forgotPasswordButton.setTitleColor(UIColor.white, for: UIControlState())
//        }else{
//            forgotPasswordButton.setTitleColor(UIColor.gray, for: UIControlState())
//        }
    }


    
    func setupLoginRegisterSegmentedControl() {
        //need x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {        
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
            inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
//        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
//        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
//        inputsContainerView.addSubview(passwordTextField)
        
        //need x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true //12
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true //12
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        
        emailTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 0).isActive = true //12
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginRegisterButton.layer.cornerRadius = 5.0
        loginRegisterButton.backgroundColor = GlobalHeadColor
        loginRegisterButton.layer.borderColor =  UIColor.white.cgColor
        loginRegisterButton.layer.borderWidth = 2.0
    }
    
    func setupForgotPasswordButton(){
        forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 12).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        forgotPasswordButton.layer.cornerRadius = 5.0
        forgotPasswordButton.backgroundColor = GlobalHeadColor
        forgotPasswordButton.layer.borderColor =  UIColor.white.cgColor
        forgotPasswordButton.layer.borderWidth = 2.0
    }
    
//    func setupCloseButton() {
//        //need x, y, width, height constraints
//        CloseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        CloseButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 12).isActive = true
//        CloseButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        CloseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
extension LoginController{
    
    
    func CheckInputLogin()->Bool{
        let strName = self.nameTextField.text!
        let strEmail = self.emailTextField.text!
        let strPassword = self.passwordTextField.text!
        if(strName.isEmpty){
            SCLAlertView().showError("Name", subTitle:"をご入力ください", closeButtonTitle:"OK")
            return false
        }
        
        
//        let text = NSMutableString(string: strTrackNo) as CFMutableString
//        // 全角カナを変換
//        CFStringTransform(text, nil, kCFStringTransformFullwidthHalfwidth, false)
//        strTrackNo = text as String
//
//        if( (strTrackNo.characters.count<5)
//            || strTrackNo.characters.count>30 ){
//            //let alert = SCLAlertView()
//            SCLAlertView().showError("追跡番号", subTitle:"追跡番号の入力桁数に誤りがあります", closeButtonTitle:"OK")
//            return false
//        }
//        if(strTrackType.isEmpty || strTrackType == "0"){
//            //let alert = SCLAlertView()
//            SCLAlertView().showError("配送業者", subTitle:"配送業者をご選択ください", closeButtonTitle:"OK")
//            return false
//        }
        return true
    }
    func CheckInputRegister()->Bool{
        let strName = self.nameTextField.text!
        let strEmail = self.emailTextField.text!
        let strPassword = self.passwordTextField.text!
        if(strName.isEmpty){
            SCLAlertView().showError("Name", subTitle:"をご入力ください", closeButtonTitle:"OK")
            return false
        }
        //        let text = NSMutableString(string: strTrackNo) as CFMutableString
        //        // 全角カナを変換
        //        CFStringTransform(text, nil, kCFStringTransformFullwidthHalfwidth, false)
        //        strTrackNo = text as String
        //
        //        if( (strTrackNo.characters.count<5)
        //            || strTrackNo.characters.count>30 ){
        //            //let alert = SCLAlertView()
        //            SCLAlertView().showError("追跡番号", subTitle:"追跡番号の入力桁数に誤りがあります", closeButtonTitle:"OK")
        //            return false
        //        }
        //        if(strTrackType.isEmpty || strTrackType == "0"){
        //            //let alert = SCLAlertView()
        //            SCLAlertView().showError("配送業者", subTitle:"配送業者をご選択ください", closeButtonTitle:"OK")
        //            return false
        //        }
        return true
    }
    
    
    
    
}








