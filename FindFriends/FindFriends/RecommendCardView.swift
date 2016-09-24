//
//  RecommendCardView.swift
//  FindFriends
//
//  Created by jiao qing on 14/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

protocol RecommendCardViewDelegate : NSObjectProtocol{
    func recommendCardViewDidClickSay(recommendCardView : RecommendCardView)
    func recommendCardViewDidUser(recommendCardView : RecommendCardView)
}

class RecommendCardView: UIView {
    var friendInfo : FriendInfo?
    weak var delegate : RecommendCardViewDelegate?
    
    init(frame: CGRect, friendInfo : FriendInfo) {
        super.init(frame: frame)
        
        self.friendInfo = friendInfo
        buildView()
    }
    
    func buildView(){
        if friendInfo == nil {
            return
        }
        
        let bigIV = UIImageView(frame : CGRectMake(15, 15, frame.size.width - 15 * 2, frame.size.height - 15 - 80 - 50))
        addSubview(bigIV)
        bigIV.contentMode = .ScaleAspectFill
        bigIV.clipsToBounds = true
        bigIV.userInteractionEnabled = true
        bigIV.addTapGestureTarget(self, action: #selector(didClickBigIV))
        
        //
        if let iu = friendInfo!.imageUrl{
            if let url = NSURL(string : iu){
                bigIV.sd_setImageWithURL(url)
            }
        }
        
        //        if let sex = friendInfo!.isFemale{
        //            if sex {
        //                bigIV.backgroundColor = UIColor(fromHexString: "FFB6C1", alpha: 0.8)
        //            }else{
        //                bigIV.backgroundColor = UIColor(fromHexString: "6495ED", alpha: 0.8)
        //            }
        //        }
        
        //  let handler = {(info : FriendInfo?) -> Void in
        //     if let friend = info {
        let topLeftIV = UIImageView(frame : CGRectMake(5, 5, 70, 70))
        topLeftIV.backgroundColor = UIColor.whiteColor()
        topLeftIV.layer.cornerRadius = topLeftIV.frame.size.width / 2
        topLeftIV.layer.borderColor = UIColor.lightGrayColor().CGColor
        topLeftIV.layer.borderWidth = 0.5
        topLeftIV.contentMode = .ScaleAspectFill
        topLeftIV.clipsToBounds = true
        topLeftIV.userInteractionEnabled = true
        topLeftIV.addTapGestureTarget(self, action: #selector(self.didClickBigIV))
        self.addSubview(topLeftIV)
        //                if let imageStr = friend.imageUrl{
        if let url = NSURL(string : "https://wallpaperscraft.com/image/asian_girl_grass_flowers_88742_1920x1080.jpg"){
            topLeftIV.sd_setImageWithURL(url)
        }
        // }
        //     }
        //  }
        
        //        ConfigDataContainer.sharedInstance.getFriendInfoById(friendInfo!.throughFriendId, handler)
        
        let nameLabel = UILabel(frame : CGRectMake(0, CGRectGetMaxY(bigIV.frame) + 10, frame.size.width, 30))
        nameLabel.text = friendInfo!.name
        nameLabel.textAlignment = .Center
        nameLabel.withTextColor(UIColor.defaultBlack()).withFontHeletica(16)
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
        sayBtn.addTarget(self, action: #selector(didClickSayBtn), forControlEvents: .TouchUpInside)
        addSubview(sayBtn)
        
        
        let infoLabel = UILabel(frame : CGRectMake(0, CGRectGetMaxY(nameLabel.frame) + 33, frame.size.width, 30))
        infoLabel.text = "You both like dance, try to say hi!"
        infoLabel.textAlignment = .Center
        infoLabel.withTextColor(UIColor.defaultBlack()).withFontHeletica(16)
        addSubview(infoLabel)
    }
    
    func didClickBigIV(){
        delegate?.recommendCardViewDidUser(self)
    }
    
    func didClickSayBtn(){
        self.delegate?.recommendCardViewDidClickSay(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
