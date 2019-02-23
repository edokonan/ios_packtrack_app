

import UIKit
class CompanyHeadView: UIImageView {

    let iconView: MyCompanyHeadView = MyCompanyHeadView.instance()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage.imageWithColor(GlobalHeadColor,
                               size: CGSize.init(width: 100, height: 100),
                               alpha: 1)
        addSubview(iconView)
        self.isUserInteractionEnabled = true
    }
    var tracktype:TrackComType?
    convenience init(frame: CGRect, tracktype:TrackComType) {
        self.init(frame: frame)
        self.tracktype = tracktype
        iconView.setInitUI(tracktype:self.tracktype)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
}
