//
//  BarButtonItemViewController.swift
//  MaterialKit
//
//  Created by Le Van Nghia on 11/29/14.
//  Copyright (c) 2014 Le Van Nghia. All rights reserved.
//

import UIKit
//import ZBarSDK
import LBXScan


class TrackNoAddViewController: UIViewController , UITextFieldDelegate ,
     UIImagePickerControllerDelegate{//, UIScrollViewDelegate ZBarReaderDelegate,
//    let trackMainModel = TrackMainModel()//model
    
    @IBOutlet weak var FiveAdView: UIView!
    @IBOutlet weak var FiveAdViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnTrackStart: MKButton!
    @IBOutlet weak var btnTrackAdd: MKButton!
    @IBOutlet weak var btnTrackType: MKButton!
    @IBOutlet weak var textTrackNo: MKTextField!
    @IBOutlet weak var textComent: MKTextField!
    @IBOutlet weak var textCommentTitle: MKTextField!
    //@IBOutlet weak var label1: MKLabel!
    //@IBOutlet weak var label2: MKLabel!
    //@IBOutlet var imageView: MKImageView!
    var strTrackNo : String = ""
    var oldstrTrackNo : String = ""
    var strTrackType : String = ""
    var strComment : String = ""
    var strCommentTitle : String = ""
    var intFormHomeView : Int = 0  //0:add 1:edit
    var homeViewController : TrackMainViewController?
    
    let comfunc = ComFunc()
    //var trackMain : TrackMain = TrackMain()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 80.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        UINavigationBar.appearance().barStyle = UIBarStyle.Default
        self.navigationController?.navigationBar.tintColor = UIColor.white

        //label1.text = "test"
        textCommentTitle.layer.borderColor = UIColor.clear.cgColor
        textCommentTitle.floatingPlaceholderEnabled = true
        textCommentTitle.placeholder = "品名"
        textCommentTitle.rippleLocation = .right
        textCommentTitle.cornerRadius = 5
        textCommentTitle.bottomBorderEnabled = false
        textCommentTitle.tintColor = UIColor.MKColor.BlueGrey
        textCommentTitle.textColor = UIColor.MKColor.BlueGrey
        
        // No border, no shadow, floatingPlaceholderEnabled
        textComent.layer.borderColor = UIColor.clear.cgColor
        textComent.floatingPlaceholderEnabled = true
        textComent.placeholder = "備考"
        textComent.rippleLocation = .right
        textComent.cornerRadius = 5
        textComent.bottomBorderEnabled = true
        textComent.tintColor = UIColor.MKColor.BlueGrey
        textComent.textColor = UIColor.MKColor.BlueGrey
        
        textTrackNo.layer.borderColor = UIColor.clear.cgColor
        textTrackNo.placeholder = "追跡番号をご入力"
        textTrackNo.textColor = UIColor.orange
        textTrackNo.backgroundColor = UIColor(hex: 0xE0E0E0)
        textTrackNo.tintColor = UIColor.MKColor.Blue//UIColor.grayColor()
        
        textComent.delegate = self;
        textCommentTitle.delegate = self;
        textTrackNo.delegate = self;
        //添加切换
        makeKeybord()
        
        
        //textTrackNo.layer.shadowOpacity = 0.55
        //textTrackNo.layer.shadowRadius = 5.0
        //textTrackNo.layer.shadowColor = UIColor.grayColor().CGColor
        //textTrackNo.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        textTrackNo.clearsOnBeginEditing = true//再次编辑就清空

        btnTrackType.backgroundColor = UIColor(hex: 0xE0E0E0)
        //btnTrackType.layer.shadowOpacity = 0.55
        //btnTrackType.layer.shadowRadius = 5.0
        //btnTrackType.layer.shadowColor = UIColor.grayColor().CGColor
        //btnTrackType.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        btnTrackType.titleLabel!.text = "配送業者をご選択"
        btnTrackType.setTitleColor(UIColor.orange, for: UIControlState())
        btnTrackType.titleLabel!.font = UIFont(name: "Helvetica-Bold",size: CGFloat(20))
        btnTrackType.titleLabel!.textAlignment = NSTextAlignment.center
        
        btnTrackStart.layer.shadowOpacity = 0.55
        btnTrackStart.layer.shadowRadius = 5.0
        btnTrackStart.layer.shadowColor = UIColor.gray.cgColor
        btnTrackStart.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        btnTrackStart.titleLabel!.font = UIFont(name: "Helvetica-Bold",size: CGFloat(25))
        
        btnTrackAdd.layer.shadowOpacity = 0.55
        btnTrackAdd.layer.shadowRadius = 5.0
        btnTrackAdd.layer.shadowColor = UIColor.gray.cgColor
        btnTrackAdd.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        btnTrackAdd.titleLabel!.font = UIFont(name: "Helvetica-Bold",size: CGFloat(25))
        
        self.setInitView()
        #if FREE
        self.initAdmobView()
        #else
        self.FiveAdViewHeight.constant=0
        #endif
    }

    
    //MARK:切换输入文字和数字
    let chagerKeyboardItem = UIBarButtonItem.init(title: "abc", style: .plain,
                                                  target: self, action: #selector(changeButtonTapped))
    func makeKeybord(){
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = .default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.commitButtonTapped))
        kbToolBar.items = [ spacer, commitButton,chagerKeyboardItem]
        textTrackNo.inputAccessoryView = kbToolBar
    }
    func initchagerKeyboardItem(){
        textTrackNo.keyboardType = .numberPad
        chagerKeyboardItem.title = "abc"
    }
    func changeButtonTapped (){
        if textTrackNo.keyboardType != .twitter {
            textTrackNo.keyboardType = .twitter
            chagerKeyboardItem.title = "123"
        }else{
            textTrackNo.keyboardType = .decimalPad
            chagerKeyboardItem.title = "abc"
        }
        textTrackNo.reloadInputViews()
    }
    func commitButtonTapped (){
        self.view.endEditing(true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(intFormHomeView == 0 ){
            self.btnTrackAdd.titleLabel!.text = "追加"
        }else{
            self.btnTrackAdd.titleLabel!.text = "修正"
            btnTrackAdd.reloadInputViews()
            self.textComent.text = strComment
            self.textCommentTitle.text = strCommentTitle
            self.textTrackNo.text = strTrackNo
            self.setTrackType(self.strTrackType)
        }
        
        initchagerKeyboardItem()
    }
    func setInitView(){
        if(intFormHomeView == 0 ){
            self.btnTrackAdd.titleLabel!.text = "追加"
            self.title = "追加"
            self.strTrackNo = ""
            self.strTrackType = "0"
            self.strComment = ""
            self.strCommentTitle = ""
            self.textComent.text = strComment
            self.textCommentTitle.text = strCommentTitle
            self.textTrackNo.text = strTrackNo
            self.setTrackType(self.strTrackType)
        }else{
            self.btnTrackAdd.titleLabel!.text = "修正"
            self.title = "修正"
            btnTrackAdd.reloadInputViews()
        }
    }
    
    
    
    
    //改行ボタンが押された際に呼ばれる.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func closeKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    @IBAction func btnSelectCompany(_ sender: AnyObject) {
        self.view.endEditing(true)
        btnTrackType.titleLabel!.reloadInputViews()
        let alert = SCLAlertView()
        alert.addButton(comfunc.getCompanyName(comfunc.Company_jppost)) {self.setTrackType(self.comfunc.Company_jppost)}
        alert.addButton(comfunc.getCompanyName(comfunc.Company_yamato)) {self.setTrackType(self.comfunc.Company_yamato)}
        alert.addButton(comfunc.getCompanyName(comfunc.Company_sagawa)) {self.setTrackType(self.comfunc.Company_sagawa)}
        alert.addButton(comfunc.getCompanyName(comfunc.Company_tmg)) {
            self.setTrackType(self.comfunc.Company_tmg)}
        
        alert.addButton(comfunc.getCompanyName(comfunc.Company_seino)) {self.setTrackType(self.comfunc.Company_seino)}
        alert.addButton(comfunc.getCompanyName(comfunc.Company_nittsu)) {self.setTrackType(self.comfunc.Company_nittsu)}
        alert.addButton(comfunc.getCompanyName(comfunc.Company_katlec)) {self.setTrackType(self.comfunc.Company_katlec)}
        alert.addButton(comfunc.getCompanyName(comfunc.Company_fukutsu)) {self.setTrackType(self.comfunc.Company_fukutsu)}
        //alert.addButton(comfunc.getCompanyName(comfunc.Company_fedexjp)) {self.setTrackType(self.comfunc.Company_fedexjp)}
        //alert.addButton(comfunc.getCompanyName(comfunc.Company_dhljp)) {self.setTrackType(self.comfunc.Company_dhljp)}
        //alert.addButton(comfunc.getCompanyName(comfunc.Company_usps)) {self.setTrackType(self.comfunc.Company_usps)}
        alert.showWait("", subTitle: "配送業者をご選択", closeButtonTitle:"キャンセル" )
        self.setTrackType( self.strTrackType)
        //, colorStyle: UIColor.orangeColor() 0xFF9800,  colorStyle: UIColor.MKColor.Orange
    }
    func setTrackType( _ stype : String){
        self.strTrackType = stype
        //btnTrackType.titleLabel!.text = ""
        if( self.strTrackType == "0"){
            btnTrackType.titleLabel!.text = "配送業者をご選択"
        }else{
            btnTrackType.titleLabel!.text = comfunc.getCompanyName(stype)
        }
        //btnTrackType.reloadInputViews()
    }
    
    
    // MARK: - 追加按钮
    @IBAction func btnAddAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        if(self.checkInput()){
            self.addToDB()
            if(intFormHomeView == 0){
                self.setInitView()
            }else{
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    // MARK: - 开始查询
    @IBAction func btnTrackStart(_ sender: AnyObject) {
        self.view.endEditing(true)
        if(self.checkInput()){
            guard let trackmain = self.addToDB() else{
                return
            }
            self.setInitView()
            if(self.intFormHomeView == 1){
                self.navigationController?.popToRootViewController(animated: false)
                self.homeViewController?.moveToTrackDetailVC(trackmain)
            }else{
                self.moveToDetailView(trackmain)
            }
        }
    }
   
    func animateLabelRipple() {
    }
    
    func animateImageRipple() {
    }
    
    func checkInput() -> Bool{
        strTrackNo = self.textTrackNo.text!.uppercased()
        strComment = self.textComent.text!
        strCommentTitle = self.textCommentTitle.text!
        if(strTrackNo.isEmpty){
            //let alert = SCLAlertView()
            SCLAlertView().showError("追跡番号", subTitle:"追跡番号をご入力ください", closeButtonTitle:"OK")
            return false
        }
        

        let text = NSMutableString(string: strTrackNo) as CFMutableString
        // 全角カナを変換
        CFStringTransform(text, nil, kCFStringTransformFullwidthHalfwidth, false)
        strTrackNo = text as String
        
        if( (strTrackNo.characters.count<5) || strTrackNo.characters.count>30 ){
            //let alert = SCLAlertView()
            SCLAlertView().showError("追跡番号", subTitle:"追跡番号の入力桁数に誤りがあります", closeButtonTitle:"OK")
            return false
        }
        if(strTrackType.isEmpty || strTrackType == "0"){
            //let alert = SCLAlertView()
            SCLAlertView().showError("配送業者", subTitle:"配送業者をご選択ください", closeButtonTitle:"OK")
            return false
        }
        return true
    }
    
    //insert or update
//    func addToDB() -> TrackMain? {
//        var temp : TrackMain? =  nil
//        if(self.intFormHomeView == 0 ){ //add
//            temp = trackMainModel.getAllByTrackNo(strTrackNo)
//        }else{ //edit
//            temp = trackMainModel.getAllByTrackNo(oldstrTrackNo)
//        }
//        if(temp == nil){
//            let trackmain = TrackMain()
//            trackmain.trackNo = strTrackNo
//            trackmain.trackType = strTrackType
//            trackmain.comment = strComment
//            trackmain.commentTitle = strCommentTitle
//            trackmain.status = ComFunc.TrackList_doing
//            _ = trackMainModel.add(trackmain)
//
//            PringManager.shared.addDataToFCM(bean: trackmain)
//        }else{
//            temp!.trackNo = strTrackNo
//            temp!.trackType = strTrackType
//            temp!.comment = strComment
//            temp!.commentTitle = strCommentTitle
//            if(temp!.status == ComFunc.TrackList_del){
//                temp!.status = ComFunc.TrackList_doing
//            }
//            _ = trackMainModel.updateByID(temp!)
//
//            PringManager.shared.updaKeyToFcm(oldno: oldstrTrackNo, newbean: temp!)
//        }
//        self.view.makeToast(message: "データ保存済み")
//        temp = trackMainModel.getAllByTrackNo(strTrackNo)
//        return temp
//    }
    func addToDB() -> TrackMain? {
        var temp : TrackMain? =  nil
        if(self.intFormHomeView == 0 ){ //add
//            temp = trackMainModel.getAllByTrackNo(strTrackNo)
            temp = IceCreamMng.shared.getMainBeanByTrackNo(strTrackNo)
        }else{ //edit
//            temp = trackMainModel.getAllByTrackNo(oldstrTrackNo)
            temp = IceCreamMng.shared.getMainBeanByTrackNo(oldstrTrackNo)
        }
        
        if(temp == nil){
            let trackmain = TrackMain()
            trackmain.trackNo = strTrackNo
            trackmain.trackType = strTrackType
            trackmain.comment = strComment
            trackmain.commentTitle = strCommentTitle
            trackmain.status = ComFunc.TrackList_doing
//            _ = trackMainModel.add(trackmain)
            _ = IceCreamMng.shared.addOrUpdMainAtAddView(trackmain)
            PringManager.shared.addDataToFCM(bean: trackmain)
        }else{
            temp!.trackNo = strTrackNo
            temp!.trackType = strTrackType
            temp!.comment = strComment
            temp!.commentTitle = strCommentTitle
            if(temp!.status == ComFunc.TrackList_del){
                temp!.status = ComFunc.TrackList_doing
            }
//            _ = trackMainModel.updateByID(temp!)
            _ = IceCreamMng.shared.addOrUpdMainAtAddView(temp!)
            if(intFormHomeView > 0 ){
                if(oldstrTrackNo != strTrackNo){
                    IceCreamMng.shared.deleteMainByTrackNo(oldstrTrackNo)
                }
            }
            PringManager.shared.updaKeyToFcm(oldno: oldstrTrackNo, newbean: temp!)
        }
        self.view.makeToast(message: "データ保存済み")
//        temp = trackMainModel.getAllByTrackNo(strTrackNo)
        temp = IceCreamMng.shared.getMainBeanByTrackNo(strTrackNo)
        return temp
    }
    
    
    
    
    
    
    
    
    func moveToDetailView(_ trackmain : TrackMain){
        if comfunc.isOnlyWeb(trackmain.trackType) {
            let webViewController: TrackWebViewController = self.storyboard?.instantiateViewController(withIdentifier: "trackWebView") as! TrackWebViewController
            webViewController.strTrackNo = trackmain.trackNo
            webViewController.strTrackType = trackmain.trackType
            webViewController.strComment = trackmain.comment
            webViewController.strCommentTitle = trackmain.commentTitle
//            webViewController.intFormView = 1
            webViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webViewController, animated:true)
        }else{
            let detailViewController: TrackDetailMainVC = self.storyboard?.instantiateViewController(withIdentifier: "TrackDetailMainVC") as! TrackDetailMainVC
            detailViewController.trackMain=trackmain
            detailViewController.hidesBottomBarWhenPushed = true
            detailViewController.initFromEditView=true
            self.navigationController?.pushViewController(detailViewController, animated:true)
        }
    }
    
//    var myScanVC = DIYScanViewController.init()
    func getParseStr(_ iStr : String)->String{
        if(!iStr.isEmpty){
            var uppercase = iStr.uppercased()
            //let strCount = uppercase.characters.count
            let startStr = uppercase[uppercase.startIndex]
            let endStr = uppercase[uppercase.characters.index(before: uppercase.endIndex)]
            if(startStr == "A" && endStr == "A" ){
                uppercase =  uppercase.replacingOccurrences(of: "A", with: "", options: NSString.CompareOptions.literal, range: nil)
            }
            if(startStr == "B" && endStr == "B" ){
                uppercase =  uppercase.replacingOccurrences(of: "B", with: "", options: NSString.CompareOptions.literal, range: nil)
            }
            return uppercase
        }else{
            return ""
        }
    }
    
    @IBAction func AmazonImportOrder(_ sender: Any) {
        let vc = MyWKWebViewController.init()
        let nav = MyUINavigationController.init(rootViewController: vc)
        self.present(nav, animated: true, completion: {})
    }
    
}


//    var ZBarReader: ZBarReaderViewController?
//    //扫描
//    @IBAction func actionScan(_ sender: AnyObject) {
//        if (self.ZBarReader == nil) {
//            self.ZBarReader = ZBarReaderViewController()
////            print("zbar start")
//        }
//
//        //self.ZBarReader = ZBarReaderViewController()
//        self.ZBarReader?.readerDelegate = self
//        //self.ZBarReader?.scanner.setSymbology(ZBAR_UPCA, config: ZBAR_CFG_ENABLE, to: 1)
//        self.ZBarReader?.scanner.setSymbology(ZBAR_CODABAR, config: ZBAR_CFG_ENABLE, to: 1)
//        self.ZBarReader?.readerView.zoom = 1
//        self.ZBarReader?.isModalInPopover = true
//        self.ZBarReader?.showsZBarControls = true
////        self.ZBarReader?.showHelp(withReason: "sdfdf")
////        self.ZBarReader?.setToolbarItems(nil, animated: true)
//        //navigationController?.pushViewController(self.ZBarReader!, animated:true)
////        self.ZBarReader?.scanCrop = CGRect(x: 0, y: 0.2, width: 1, height: 0.6)
//        self.ZBarReader?.scanCrop = CGRect(x: 0.35, y: 0, width:  0.3, height: 1)
//        let rectview = ScanCropView.instanceFromNib()
//        rectview.frame = CGRect(x: 0, y: 0, width:  screenWidth ,
//                                                       height: screenHeight)
//        self.ZBarReader?.cameraOverlayView = rectview
//        self.present(self.ZBarReader!, animated: true, completion: nil)
////        print(self.ZBarReader?.cameraMode)
////        print("zbar end")
//    }
//    func imagePickerController(_ reader: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [String: Any]) {
//        // ADD: get the decode results
//        let results: NSFastEnumeration = info[ZBarReaderControllerResults] as! NSFastEnumeration
//        var symbolFound : ZBarSymbol?
//        for symbol in results as! ZBarSymbolSet {
//            symbolFound = symbol as? ZBarSymbol
//            break
//        }
//        let resultString = NSString(string: symbolFound!.data)
//        let retStr = getParseStr(resultString as String)
//        self.textTrackNo.text = retStr
//        //self.resultText.text = resultString as String    //set barCode
//        //self.resultImage.image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        dismiss(animated: true, completion: nil)
//    }


//extension ZBarSymbolSet: Sequence {
//    public func makeIterator() -> NSFastEnumerationIterator {
//        return NSFastEnumerationIterator(self)
//    }
//}

