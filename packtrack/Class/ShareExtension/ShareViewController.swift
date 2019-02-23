//
//  ShareViewController.swift
//  deegeu-swift-share-extensions-image-share
//
//  Created by Daniel Spiess on 10/26/15.
//  Copyright © 2015 Daniel Spiess. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController, ColorSelectionViewControllerDelegate {

    let suiteName = "group.com.ksyapp.packtrack.shareextension"
    let key_sharedata = "packtrack_shareextension_key_add"
    let redDefaultKey = "RedColorImage"
    let blueDefaultKey = "BlueColorImage"
    
    var selectedImage: UIImage?
    var selectedCompanyName = "日本郵便"
    var selectedCompanyNo = "1"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // This method is used to validate the input from the user. If they type too many characters,
    // or select something invalid, this returns false.
    override func isContentValid() -> Bool {
        return true
    }

    // Called after the user selects an image from the photos
    override func didSelectPost() {
        print(self.contentText)
        savePacktrackNo(self.contentText, company: selectedCompanyNo)
        
//        // This is called after the user selects Post.
//        // Make sure we have a valid extension item
//        if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
//            let contentType = kUTTypeImage as String
//            let puclicURL = String(kUTTypeURL)  // "public.url"
//            // Verify the provider is valid
//            if let contents = content.attachments as? [NSItemProvider] {
//                // look for images
//                for attachment in contents {
//                    if attachment.hasItemConformingToTypeIdentifier(contentType) {
//                        attachment.loadItem(forTypeIdentifier: contentType, options: nil) { data, error in
//                            let url = data as! URL
//                            if (!self.selectedColorName.isEmpty) {
//                                if let imageData = try? Data(contentsOf: url) {
//                                    if (self.selectedColorName == "Default") {
//                                        self.saveImage(self.redDefaultKey, imageData: imageData)
//                                        self.saveImage(self.blueDefaultKey, imageData: imageData)
//                                    } else if (self.selectedColorName == "Red") {
//                                        self.saveImage(self.redDefaultKey, imageData: imageData)
//                                    } else {
//                                        // must be blue
//                                        self.saveImage(self.blueDefaultKey, imageData: imageData)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
        // Inform the host that we're done, so it un-blocks its UI.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    // Returns an array of colors. In our case it's red, blue or default. These are built configuration
    // items, not just the string.
    override func configurationItems() -> [Any]! {
        return [colorConfigurationItem]
    }
    
    // Builds a configuration item when we need it. This one is for the "Color" 
    // configuration item.
    lazy var colorConfigurationItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()
        item?.title = "配達業者"
        item?.value = self.selectedCompanyName
        item?.tapHandler = self.showColorSelection
        return item!
    }()
    
    // Shows a view controller when the user selects a configuration item
    func showColorSelection() {
        let controller = ColorSelectionViewController(style: .plain)
        controller.selectedCompanyName = colorConfigurationItem.value
        controller.delegate = self
        pushConfigurationViewController(controller)
    }

    // One the user selects a configuration item (color), we remember the value and pop
    // the color selection view controller
    func colorSelection(_ sender: ColorSelectionViewController, companyName: String, companyValue: String) {
        colorConfigurationItem.value = selectedCompanyName
        selectedCompanyName = companyName
        selectedCompanyNo = companyValue
        
        colorConfigurationItem.value = companyName
        popConfigurationViewController()
    }

    // Saves an image to user defaults.
    func saveImage(_ color: String, imageData: Data) {
        if let prefs = UserDefaults(suiteName: suiteName) {
            prefs.removeObject(forKey: color)
            prefs.set(imageData, forKey: color)
        }
    }

    // Saves an image to user defaults.
    func savePacktrackNo(_ no: String, company: String) {
        var dic:Dictionary<String,Dictionary<String, String>> = [:]
        if let prefs = UserDefaults(suiteName: suiteName) {
            let uuid: String = String.init(format: "add-%.0f", Double(Date().timeIntervalSince1970))
            if var newdic = prefs.object(forKey: key_sharedata) as? Dictionary<String, Dictionary<String, String>>{
                newdic[uuid] =  ["no": no, "company": company]
                prefs.setValue(newdic, forKey: key_sharedata)
            }else{
                dic[uuid] =  ["no": no, "company": company]
                prefs.setValue(dic, forKey: key_sharedata)
            }
        }
    }
}
