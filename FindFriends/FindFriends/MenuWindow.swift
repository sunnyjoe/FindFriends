//
//  ProfileWindow.swift
//  FindFriends
//
//  Created by jiao qing on 14/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

protocol MenuWindowDelegate : NSObjectProtocol{
    func menuWindowDidClickNearby(menuWindow : MenuWindow)
    func menuWindowDidClickActivity(menuWindow : MenuWindow)
    func menuWindowDidClickSetting(menuWindow : MenuWindow)
    
}

class MenuWindow: UIWindow {
    let headerView = UIView(frame : CGRectMake(0, 0, 200, 200))
    
    weak var delegate : MenuWindowDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blueColor()
        
        let bgV = UIImageView(frame : bounds)
        addSubview(bgV)
        bgV.image = UIImage(named: "MenuBG")
        
        
        addSubview(headerView)
        
        let handler = {(info : FriendInfo?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                let fake1 = FriendInfo()
                fake1.name = "Xu Ran"
                fake1.careerInfo = "Supply Chain"
                fake1.selfIntroduction = "Seeking God's love"
                fake1.isFemale = true
                fake1.imageUrl = "http://beauty.pclady.com.cn/sszr/0601/pic/20060117_bb_9.jpg"
                
                self.buildHeaderView(fake1)
            })
        }
        
        ConfigDataContainer.sharedInstance.getMyInfo(handler)
        
        var oy : CGFloat = 150
        addMoreLabel(oy, "My Links")
        
        oy += 35
        addMoreLabel(oy, "Nearby Friends", #selector(didTapNearby))
        
        oy += 35
        addMoreLabel(oy, "Activities", #selector(didTapActivity))
        
        oy += 35
        addMoreLabel(oy, "Recent")
        
        oy += 35
        addMoreLabel(oy, "Setting", #selector(didTapSetting))
    }
    
    func didTapNearby(){
        delegate?.menuWindowDidClickNearby(self)
    }
    
    func didTapActivity(){
        delegate?.menuWindowDidClickActivity(self)
    }
    
    func didTapSetting(){
        delegate?.menuWindowDidClickSetting(self)
    }
    
    func addMoreLabel(oy : CGFloat, _ text : String, _ sel : Selector? = nil) {
        let label = UILabel().withText(text).withTextColor(UIColor.whiteColor()).withFontHeletica(16)
        label.frame = CGRectMake(20, oy, 200, 50)
        if sel != nil {
            label.addTapGestureTarget(self, action: sel!)
        }
        addSubview(label)
    }
    
    func buildHeaderView(info : FriendInfo?){
        let photoIV = UIImageView(frame : CGRectMake(20, 30, 75, 75))
        photoIV.layer.cornerRadius = photoIV.frame.size.width / 2
        photoIV.layer.borderColor = UIColor.lightGrayColor().CGColor
        photoIV.layer.borderWidth = 0.5
        photoIV.contentMode = .ScaleAspectFill
        photoIV.clipsToBounds = true
        headerView.addSubview(photoIV)
        
        if info == nil{
            return
        }
        
        if let imageStr = info!.imageUrl{
            if let url = NSURL(string : imageStr){
                photoIV.sd_setImageWithURL(url)
            }
        }
        
        let nameLabel = UILabel(frame : CGRectMake(CGRectGetMaxX(photoIV.frame) + 10, 50, 100, 30))
        nameLabel.withText(info!.name).withTextColor(UIColor.whiteColor()).withFontHeletica(15)
        headerView.addSubview(nameLabel)
        
        let infoLabel = UILabel(frame : CGRectMake(CGRectGetMaxX(photoIV.frame) + 10, CGRectGetMaxY(nameLabel.frame), frame.size.width - 20 - CGRectGetMaxX(photoIV.frame) - 10, 30))
        if let text = info!.selfIntroduction{
            infoLabel.withText(text).withTextColor(UIColor.whiteColor())
            infoLabel.font = UIFont.italicFont(15)
        }
        headerView.addSubview(infoLabel)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
