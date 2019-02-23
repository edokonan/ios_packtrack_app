//
//  BTConfiguration.swift
//  BTNavigationDropdownMenu
//
//  Created by Pham Ba Tho on 6/30/15.
//  Copyright (c) 2015 PHAM BA THO. All rights reserved.
//

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit


protocol BTNavigationDropdownMenu_Delegate {
    
    func showDropdownMenu()
    
    func hideDropdownMenu()

}

// MARK: BTNavigationDropdownMenu
open class BTNavigationDropdownMenu: UIView {
    
    var delegate : BTNavigationDropdownMenu_Delegate?
    
    // The height of the cell. Default is 50
    open var cellHeight: CGFloat! {
        didSet {
            self.configuration.cellHeight = cellHeight
        }
    }
    
    // The color of the cell background. Default is whiteColor()
    open var cellBackgroundColor: UIColor! {
        didSet {
            self.configuration.cellBackgroundColor = cellBackgroundColor
        }
    }
    
    // The color of the text inside cell. Default is darkGrayColor()
    open var cellTextLabelColor: UIColor! {
        didSet {
            self.configuration.cellTextLabelColor = cellTextLabelColor
        }
    }
    
    // The font of the text inside cell. Default is HelveticaNeue-Bold, size 19
    open var cellTextLabelFont: UIFont! {
        didSet {
            self.configuration.cellTextLabelFont = cellTextLabelFont
            self.menuTitle.font = self.configuration.cellTextLabelFont
        }
    }
    
    // The color of the cell when the cell is selected. Default is lightGrayColor()
    open var cellSelectionColor: UIColor! {
        didSet {
            self.configuration.cellSelectionColor = cellSelectionColor
        }
    }
    
    // The checkmark icon of the cell
    open var checkMarkImage: UIImage! {
        didSet {
            self.configuration.checkMarkImage = self.checkMarkImage
        }
    }
    
    // The animation duration of showing/hiding menu. Default is 0.3
    open var animationDuration: TimeInterval! {
        didSet {
            self.configuration.animationDuration = animationDuration
        }
    }

    // The arrow next to navigation title
    open var arrowImage: UIImage! {
        didSet {
            self.configuration.arrowImage = arrowImage
            self.menuArrow.image = self.configuration.arrowImage
        }
    }
    
    // The padding between navigation title and arrow
    open var arrowPadding: CGFloat! {
        didSet {
            self.configuration.arrowPadding = arrowPadding
        }
    }
    
    // The color of the mask layer. Default is blackColor()
    open var maskBackgroundColor: UIColor! {
        didSet {
            self.configuration.maskBackgroundColor = maskBackgroundColor
        }
    }
    
    // The opacity of the mask layer. Default is 0.3
    open var maskBackgroundOpacity: CGFloat! {
        didSet {
            self.configuration.maskBackgroundOpacity = maskBackgroundOpacity
        }
    }
    
    open var didSelectItemAtIndexHandler: ((_ indexPath: Int) -> ())?

    // Private properties
    fileprivate var tableContainerView: UIView!
    fileprivate var configuration: BTConfiguration!
    fileprivate var mainScreenBounds: CGRect!
    fileprivate var menuButton: UIButton!
    var menuTitle: UILabel!
    var menuArrow: UIImageView!
    fileprivate var backgroundView: UIView!
    fileprivate var tableView: BTTableView!
    fileprivate var items: [AnyObject]!
     var isShown: Bool!
    fileprivate var navigationBarHeight: CGFloat!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(frame: CGRect, title: String, items: [AnyObject], containerView:UIView) {
        super.init(frame:frame)
        
        // Init properties
        self.configuration = BTConfiguration()
        self.tableContainerView = containerView
        self.navigationBarHeight = 44
        
//        self.mainScreenBounds = UIScreen.main.bounds
        setMainScreenBounds()
        self.isShown = false
        self.items = items
        
        // Init button as navigation title
        self.menuButton = UIButton(frame: frame)
        self.menuButton.addTarget(self, action: "menuButtonTapped:", for: UIControlEvents.touchUpInside)
        self.addSubview(self.menuButton)
        
        self.menuTitle = UILabel(frame: frame)
        self.menuTitle.text = title
        self.menuTitle.textColor = UINavigationBar.appearance().titleTextAttributes?[NSForegroundColorAttributeName] as? UIColor
        self.menuTitle.textAlignment = NSTextAlignment.center
        self.menuTitle.font = self.configuration.cellTextLabelFont
        self.menuButton.addSubview(self.menuTitle)
        
        self.menuArrow = UIImageView(image: self.configuration.arrowImage)
        self.menuButton.addSubview(self.menuArrow)
        
        // Init table view
        let frame = CGRect(x: mainScreenBounds.origin.x,
                          y: mainScreenBounds.origin.y,
                          width: mainScreenBounds.width,
                          height: mainScreenBounds.height + 300 - 64 - self.configuration.cellHeight)
        self.tableView = BTTableView(frame: frame,//mainScreenBounds.height + 300 - 64
            items: items, configuration: self.configuration)
        self.tableView.selectRowAtIndexPathHandler = { (indexPath: Int) -> () in
            self.didSelectItemAtIndexHandler!(indexPath)
            self.setMenuTitle1("\(items[indexPath])")
            self.hideMenu()
            self.isShown = false
            self.layoutSubviews()
        }
    }
//    @Override
//    public void onConfigurationChanged(Configuration newConfig) {
//    super.onConfigurationChanged(newConfig);
//    if (newOrientation == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT) {
//    ...
//    setContentView(R.layout.main);
//    } else if (newOrientation == ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT) {
//    ...
//    setContentView(R.layout.main_reverse_portrait);
//    }
//    }

    func setMainScreenBounds(){
//        if (UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
//                self.mainScreenBounds = UIScreen.main.bounds
//        }else{
//                self.mainScreenBounds = CGRect.init(x: 0, y: 0,
//                                                    width: UIScreen.main.bounds.height,
//                                                    height: UIScreen.main.bounds.width)
//        }
        
        self.mainScreenBounds = UIScreen.main.bounds
        print(self.mainScreenBounds)
    }
    override open func layoutSubviews() {
        self.menuTitle.sizeToFit()
        self.menuTitle.center = CGPoint(x: self.frame.size.width/2,
                                        y: self.frame.size.height/2)
        self.menuArrow.sizeToFit()
        self.menuArrow.center = CGPoint(x: self.menuTitle.frame.maxX + self.configuration.arrowPadding,
                                        y: self.frame.size.height/2)
    }
    
    func resizeTableView(){
        setMainScreenBounds()
        var frame = CGRect(x: mainScreenBounds.origin.x,
                           y: mainScreenBounds.origin.y,
                           width: mainScreenBounds.width,
                           height: mainScreenBounds.height + 300 - 64 - self.configuration.cellHeight)

//        if (UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
//            //DO Portrait
//        }else{
//            //DO Landscape
//            frame = CGRect(x: mainScreenBounds.origin.y,
//                                           y: mainScreenBounds.origin.x,
//                                           width: mainScreenBounds.height,
//                                           height: mainScreenBounds.width + 300 - 64 - self.configuration.cellHeight )
//        }
//        print(frame)
//
//        self.frame=frame
        self.tableView.frame = frame
//        self.backgroundView.frame = frame
//        self.setNeedsLayout()
        //        self.layoutIfNeeded()
//        self.tableView.reloadData()
//        self.layoutSubviews()
    }
    
    func showMenu() {
        // Rotate arrow
        self.rotateArrow()
//        resizeTableView()
//
//        // Table view header
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 300))
//        headerView.backgroundColor = self.configuration.cellBackgroundColor
//        self.tableView.tableHeaderView = headerView
//
//        // Reload data to dismiss highlight color of selected cell
//        self.tableView.reloadData()
//
//        // Init background view (under table view)
//        self.backgroundView = UIView(frame: mainScreenBounds)
//        self.backgroundView.backgroundColor = self.configuration.maskBackgroundColor
//        self.backgroundView.isUserInteractionEnabled = true
////
//        // Add background view & table view to container view
//        self.tableContainerView.addSubview(self.backgroundView)
//        self.tableContainerView.addSubview(self.tableView)
//
//        // Change background alpha
//        self.backgroundView.alpha = 0
//        // Animation
//        self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - 300
//
//        UIView.animate(
//            withDuration: 0.25,//self.configuration.animationDuration,
//            delay: 0,
//            usingSpringWithDamping: 0.9,
//            initialSpringVelocity: 0.5,
//            options: [],
//            animations: {
//                self.tableView.frame.origin.y = CGFloat(-300)
//                self.backgroundView.alpha = self.configuration.maskBackgroundOpacity
//            }, completion: nil
//        )
    }
    let gesture = UITapGestureRecognizer(target: self, action:#selector(hideMenu))
//    func backgroudviewTapped(_ sender: UIView) {
//            self.hideMenu()
//    }
//
    func hideMenu() {
        // Rotate arrow
        self.rotateArrow()
        
//        // Change background alpha
//        self.backgroundView.alpha = self.configuration.maskBackgroundOpacity
//
//        UIView.animate(
//            withDuration: self.configuration.animationDuration * 1.5,
//            delay: 0,
//            usingSpringWithDamping: 0.7,
//            initialSpringVelocity: 0.5,
//            options: [],
//            animations: {
//                self.tableView.frame.origin.y = CGFloat(-200)
//            }, completion: nil
//        )
//
//        // Animation
//        UIView.animate(withDuration: self.configuration.animationDuration, delay: 0, options: UIViewAnimationOptions(), animations: {
//            self.tableView.frame.origin.y = -CGFloat(self.items.count) * self.configuration.cellHeight - 300
//            self.backgroundView.alpha = 0
//        }, completion: { _ in
//            self.tableView.removeFromSuperview()
//            self.backgroundView.removeFromSuperview()
//        })
    }
    
    func rotateArrow() {
        UIView.animate(withDuration: self.configuration.animationDuration,
                       animations: {[weak self] () -> () in
            if let selfie = self {
                selfie.menuArrow.transform = selfie.menuArrow.transform.rotated(by: 180 * CGFloat(M_PI/180))
            }
        })
    }
    
    func setMenuTitle1(_ title: String) {
        self.menuTitle.text = title
//        self.menuTitle.setNeedsLayout()
//        layoutSubviews()
        self.menuButton.addSubview(self.menuTitle)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
//
    func menuButtonTapped(_ sender: UIButton) {
        self.isShown = !self.isShown
        if self.isShown == true {
//            self.showMenu()
//            self.menuArrow.transform = self.menuArrow.transform.rotated(by: 180 * CGFloat(M_PI/360))
            self.delegate?.showDropdownMenu()
        } else {
//            self.menuArrow.transform = self.menuArrow.transform.rotated(by: 180 * CGFloat(M_PI/180))
            self.delegate?.hideDropdownMenu()
//            self.hideMenu()
        }
    }
    
    func rotateArrowToOpen() {
        UIView.animate(withDuration: self.configuration.animationDuration,
                       animations: {[weak self] () -> () in
                        if let selfie = self {
                            selfie.menuArrow.transform = selfie.menuArrow.transform.rotated(by: 180 * CGFloat(M_PI/180))
                        }
        })
    }
    func rotateArrowToClose() {
        UIView.animate(withDuration: self.configuration.animationDuration,
                       animations: {[weak self] () -> () in
                        if let selfie = self {
                            selfie.menuArrow.transform = selfie.menuArrow.transform.rotated(by: 180 * CGFloat(M_PI/180))
                        }
        })
    }
    
}

// MARK: BTConfiguration
class BTConfiguration {
    var cellHeight: CGFloat!
    var cellBackgroundColor: UIColor!
    var cellTextLabelColor: UIColor!
    var cellTextLabelFont: UIFont!
    var cellSelectionColor: UIColor!
    var checkMarkImage: UIImage!
    var arrowImage: UIImage!
    var arrowPadding: CGFloat!
    var animationDuration: TimeInterval!
    var maskBackgroundColor: UIColor!
    var maskBackgroundOpacity: CGFloat!
    
    init() {
        self.defaultValue()
    }
    
    func defaultValue() {
        // Path for image
        let bundle = Bundle(for: BTConfiguration.self)
//        let url = bundle.url(forResource: "BTNavigationDropdownMenu", withExtension: "bundle")
//        let imageBundle = Bundle(url: url!)
//        let checkMarkImagePath = imageBundle?.path(forResource: "checkmark_icon", ofType: "png")
//        let arrowImagePath = imageBundle?.path(forResource: "arrow_down_icon", ofType: "png")
        
//        let checkMarkImagePath = UIImage.init(named: "checkmark_icon")
//        let arrowImagePath = UIImage.init(named: "arrow_down_icon")

        // Default values
        self.cellHeight = 50
        self.cellBackgroundColor = UIColor.white
        self.cellTextLabelColor = UIColor.darkGray
        self.cellTextLabelFont = UIFont(name: "HelveticaNeue-Bold", size: 17)
        self.cellSelectionColor = UIColor.lightGray
        self.checkMarkImage = UIImage.init(named: "checkmark_icon")
        self.animationDuration = 0.2
        self.arrowImage = UIImage.init(named: "arrow_down_icon")
        self.arrowPadding = 15
        self.maskBackgroundColor = UIColor.black
        self.maskBackgroundOpacity = 0.3
    }
}

// MARK: Table View
class BTTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // Public properties
    var configuration: BTConfiguration!
    var selectRowAtIndexPathHandler: ((_ indexPath: Int) -> ())?
    
    // Private properties
    fileprivate var items: [AnyObject]!
    fileprivate var selectedIndexPath: Int!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, items: [AnyObject], configuration: BTConfiguration) {
        super.init(frame: frame, style: UITableViewStyle.plain)
        
        self.items = items
        self.selectedIndexPath = 0
        self.configuration = configuration
        
        // Setup table view
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clear
        self.separatorStyle = UITableViewCellSeparatorStyle.none
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.configuration.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BTTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell", configuration: self.configuration)
        cell.textLabel?.text = self.items[indexPath.row] as? String
        if indexPath.row == selectedIndexPath {
            cell.checkmarkIcon.isHidden = false
        } else {
            cell.checkmarkIcon.isHidden = true
        }
        return cell
    }
    
    // Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        self.selectRowAtIndexPathHandler!(indexPath.row)
        self.reloadData()
        let cell = tableView.cellForRow(at: indexPath) as? BTTableViewCell
        cell?.contentView.backgroundColor = self.configuration.cellSelectionColor
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? BTTableViewCell
        cell?.checkmarkIcon.isHidden = true
        cell?.contentView.backgroundColor = self.configuration.cellBackgroundColor
    }
}

// MARK: Table view cell
class BTTableViewCell: UITableViewCell {
    
    var checkmarkIcon: UIImageView!
    var cellContentFrame: CGRect!
    var configuration: BTConfiguration!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, configuration: BTConfiguration) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configuration = configuration
        
        // Setup cell
        cellContentFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.configuration.cellHeight)
        self.contentView.backgroundColor = self.configuration.cellBackgroundColor
        self.selectionStyle = UITableViewCellSelectionStyle.none
        self.textLabel!.textAlignment = NSTextAlignment.left
        self.textLabel!.textColor = self.configuration.cellTextLabelColor
        self.textLabel!.font = self.configuration.cellTextLabelFont
        self.textLabel!.frame = CGRect(x: 20, y: 0, width: cellContentFrame.width, height: cellContentFrame.height)
        
        
        // Checkmark icon
        self.checkmarkIcon = UIImageView(frame: CGRect(x: cellContentFrame.width - 50, y: (cellContentFrame.height - 30)/2, width: 30, height: 30))
        self.checkmarkIcon.isHidden = true
        self.checkmarkIcon.image = self.configuration.checkMarkImage
        self.checkmarkIcon.contentMode = UIViewContentMode.scaleAspectFill
        self.contentView.addSubview(self.checkmarkIcon)
        
        // Separator for cell
        let separator = BTTableCellContentView(frame: cellContentFrame)
        separator.backgroundColor = UIColor.clear
        self.contentView.addSubview(separator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.bounds = cellContentFrame
        self.contentView.frame = self.bounds
    }
}

// Content view of table view cell
class BTTableCellContentView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        // Set separator color of dropdown menu based on barStyle
        if UINavigationBar.appearance().barStyle == UIBarStyle.default {
            context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        } else {
            context?.setStrokeColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        }
        context?.setLineWidth(1)
        context?.move(to: CGPoint(x: 0, y: self.bounds.size.height))
        context?.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
        context?.strokePath()
    }
}

