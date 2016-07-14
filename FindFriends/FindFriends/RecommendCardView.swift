//
//  RecommendCardView.swift
//  FindFriends
//
//  Created by jiao qing on 14/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class RecommendCardView: UIView {
    var friendInfo : FriendInfo?
    
    
    
    init(frame: CGRect, friendInfo : FriendInfo) {
        super.init(frame: frame)
        
        self.friendInfo = friendInfo
        buildView()
    }
    
    func buildView(){
        if friendInfo == nil {
            return
        }
        
        let bigIV = UIImageView(frame : CGRectMake(15, 15, frame.size.width - 15 * 2, frame.size.height - 15 - 80))
        addSubview(bigIV)
        bigIV.contentMode = .ScaleAspectFit
        bigIV.clipsToBounds = true
       
        if let imageStr = friendInfo!.imageUrl{
            if let url = NSURL(string : imageStr){
                bigIV.sd_setImageWithURL(url)
            }
        }
        if let sex = friendInfo!.isFemale{
            if sex {
                 bigIV.backgroundColor = UIColor(fromHexString: "FFB6C1", alpha: 0.8)
            }else{
                 bigIV.backgroundColor = UIColor(fromHexString: "6495ED", alpha: 0.8)
            }
        }
        
        if let one = ConfigDataContainer.sharedInstance.getFriendInfoById(friendInfo!.throughFriendId){
            let topLeftIV = UIImageView(frame : CGRectMake(5, 5, 70, 70))
            topLeftIV.backgroundColor = UIColor.whiteColor()
            topLeftIV.layer.cornerRadius = topLeftIV.frame.size.width / 2
            topLeftIV.layer.borderColor = UIColor.lightGrayColor().CGColor
            topLeftIV.layer.borderWidth = 0.5
            topLeftIV.contentMode = .ScaleAspectFill
            topLeftIV.clipsToBounds = true
            addSubview(topLeftIV)
            if let imageStr = one.imageUrl{
                if let url = NSURL(string : imageStr){
                    topLeftIV.sd_setImageWithURL(url)
                }
            }
        }
        
        let nameLabel = UILabel(frame : CGRectMake(0, CGRectGetMaxY(bigIV.frame) + 10, frame.size.width, 30))
        nameLabel.text = friendInfo!.name
        nameLabel.textAlignment = .Center
        nameLabel.withTextColor(UIColor.defaultBlack()).withFontHeleticaMedium(16)
        addSubview(nameLabel)
        
        if let careerInfo = friendInfo!.careerInfo {
            let infoLabel = UILabel(frame : CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + 3, frame.size.width, 30))
            infoLabel.text = careerInfo
            infoLabel.textAlignment = .Center
            infoLabel.withTextColor(UIColor.defaultBlack()).font = UIFont.italicFont(15)
            addSubview(infoLabel)
        }
        
        let sayBtn = UIButton(frame : CGRectMake(frame.size.width - 45, CGRectGetMaxY(bigIV.frame) + 10, 30, 30))
        sayBtn.withImage(UIImage(named: "CommentIcon"))
        addSubview(sayBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
