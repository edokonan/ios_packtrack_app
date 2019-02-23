//
//  PZPullRefreshView.swift
//  PZPullToRefresh
//
//  Created by pixyzehn on 3/19/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

@objc public protocol PZPullToRefreshDelegate: NSObjectProtocol {
    func pullToRefreshDidTrigger(_ view: PZPullToRefreshView) -> ()
    @objc optional func pullToRefreshLastUpdated(_ view: PZPullToRefreshView) -> Date
}

open class PZPullToRefreshView: UIView {
    
    public enum RefreshState {
        case normal
        case pulling
        case loading
    }

    open var statusTextColor = UIColor.white
    open var timeTextColor = UIColor(red:0.95, green:0.82, blue:0.79, alpha:1)
    open var bgColor = UIColor(red:0.82, green:0.44, blue:0.39, alpha:1)
    open var flipAnimatioDutation: CFTimeInterval = 0.18
    open var thresholdValue: CGFloat = 60.0
    open var lastUpdatedKey = "RefreshLastUpdated"
    open var isShowUpdatedTime: Bool = true
    
    open var _isLoading: Bool = false
    open var isLoading: Bool {
        get {
            return _isLoading
        }
        set {
            if state == .loading {
                _isLoading = true
            } else {
                _isLoading = false
            }
        }
    }
    
    fileprivate var _state: RefreshState = .normal
    open var state: RefreshState {
        get {
           return _state
        }
        set {
            switch newValue {
            case .normal:
                statusLabel?.text = "Pull down to refresh"
                activityView?.stopAnimating()
                refreshLastUpdatedDate()
                rotateArrowImage(angle: 0)
            case .pulling:
                statusLabel?.text = "Release to refresh"
                rotateArrowImage(angle: CGFloat(M_PI))
            case .loading:
                statusLabel?.text = "Loading..."
                activityView?.startAnimating()
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                arrowImage?.isHidden = true
                CATransaction.commit()
            }
            _state = newValue
        }
    }
    
    open func rotateArrowImage(angle: CGFloat) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(flipAnimatioDutation)
        arrowImage?.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        CATransaction.commit()
    }
    
    open var lastUpdatedLabel: UILabel?
    open var statusLabel: UILabel?
    open var arrowImage: CALayer?
    open var activityView: UIActivityIndicatorView?
    open var delegate: PZPullToRefreshDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.backgroundColor = bgColor

        let label: UILabel = UILabel(frame: CGRect(x: 0, y: frame.size.height - 30.0, width: self.frame.size.width, height: 20.0))
        label.autoresizingMask = UIViewAutoresizing.flexibleWidth
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = timeTextColor
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        lastUpdatedLabel = label
        if let value: AnyObject = UserDefaults.standard.object(forKey: lastUpdatedKey) as AnyObject {
            lastUpdatedLabel?.text = value as? String
        } else {
            lastUpdatedLabel?.text = nil
        }
        self.addSubview(label)
        
        let label2: UILabel = UILabel(frame: CGRect(x: 0, y: frame.size.height - 48.0, width: self.frame.size.width, height: 20.0))
        label2.autoresizingMask = UIViewAutoresizing.flexibleWidth
        label2.font = UIFont.boldSystemFont(ofSize: 14.0)
        label2.textColor = statusTextColor
        label2.backgroundColor = UIColor.clear
        label2.textAlignment = .center
        statusLabel = label2
        self.addSubview(label2)
        
        let layer: CALayer = CALayer()
        layer.frame = CGRect(x: 25.0, y: frame.size.height - 40.0, width: 15.0, height: 25.0)
        layer.contentsGravity = kCAGravityResizeAspect
        layer.contents = UIImage(named: "whiteArrow")?.cgImage
        self.layer.addSublayer(layer)
        arrowImage = layer
        
        let view: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        view.frame = CGRect(x: 25.0, y: frame.size.height - 38.0, width: 20.0, height: 20.0)
        self.addSubview(view)
        activityView = view
        
        state = .normal
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func refreshLastUpdatedDate() {
        if isShowUpdatedTime {
            if let update = delegate?.responds(to: "pullToRefreshLastUpdated:") {
                let date = delegate?.pullToRefreshLastUpdated!(self)
                let formatter = DateFormatter()
                formatter.amSymbol = "AM"
                formatter.pmSymbol = "PM"
                formatter.dateFormat = "yyyy/MM/dd/ hh:mm:a"
                lastUpdatedLabel?.text = "Last Updated: \(formatter.string(from: date!))"
                UserDefaults.standard.set(lastUpdatedLabel?.text, forKey: lastUpdatedKey)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    // MARK:ScrollView Methods
    
    open func refreshScrollViewDidScroll(_ scrollView: UIScrollView) {
        if state == .loading {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2)
            var offset = max(scrollView.contentOffset.y * -1, 0)
            offset = min(offset, thresholdValue)
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0, 0.0, 0.0)
            UIView.commitAnimations()
        } else if scrollView.isDragging {
            let loading: Bool = false
            if state == .pulling && scrollView.contentOffset.y > -thresholdValue && scrollView.contentOffset.y < 0.0 && !loading {
                state = .normal
            } else if state == .normal && scrollView.contentOffset.y < -thresholdValue && !loading {
                state = .pulling
            }
        }
    }
    
    open func refreshScrollViewDidEndDragging(_ scrollView: UIScrollView) {
        let loading: Bool = false
        if (scrollView.contentOffset.y <= -thresholdValue && !loading) {
            state = .loading
            if let load = delegate?.responds(to: "pullToRefreshDidTrigger:") {
                delegate?.pullToRefreshDidTrigger(self)
            }
        }
    }
    
    open func refreshScrollViewDataSourceDidFinishedLoading(_ scrollView: UIScrollView) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.4)
        scrollView.contentInset = UIEdgeInsets.zero
        UIView.commitAnimations()
        arrowImage?.isHidden = false
        state = .normal
    }
    
    deinit {
        delegate = nil
        activityView = nil
        statusLabel = nil
        arrowImage = nil
        lastUpdatedLabel = nil
    }
}
