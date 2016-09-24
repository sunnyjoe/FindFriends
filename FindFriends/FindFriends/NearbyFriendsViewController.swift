//
//  NearbyFriends.swift
//  FindFriends
//
//  Created by Jiao on 24/9/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import Foundation


class NearbyFriendsViewController: BasicViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
    let bannerHeight : CGFloat = 256
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nearby Friends"
        
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "EventBannersViewController")
        view.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return bannerHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let conV = UIView(frame : CGRectMake(0, 0, view.frame.size.width, bannerHeight))
        conV.backgroundColor = UIColor(fromHexString: "fafafa")
        
        let narLabel = UILabel(frame : CGRectMake(23, 0, view.frame.size.width - 23 * 2, 37))
        narLabel.withTextColor(UIColor.defaultBlack())
        narLabel.withText("< 500m").withFontHeletica(14)
        conV.addSubview(narLabel)
        
         if indexPath.row == 1 {
            narLabel.withText("500m - 1km")
        }
        
        if indexPath.row == 2 {
            narLabel.withText("> 2km")
        }
        
        let border = UIImageView(frame : CGRectMake(0, 37, view.frame.size.width, 2))
        border.backgroundColor = UIColor.darkGrayColor()
        conV.addSubview(border)
        
        let iw = (view.frame.size.width - 23 * 2 - 35) / 2
        
        
        let iv = UIImageView(frame : CGRectMake(23, 50, iw, bannerHeight - 50 - 15))
        iv.contentMode = .ScaleAspectFill
        iv.clipsToBounds = true
        
        var image1 = "http://beauty.pclady.com.cn/sszr/0601/pic/20060117_bb_9.jpg"
        var image2 = "http://www.borongaja.com/data_images/out/3/587345-cute-asian-girl.jpg"
        if indexPath.row == 1 {
            image1 = "https://wallpaperscraft.com/image/asian_girl_smile_face_88785_1920x1200.jpg"
            image2 = "https://img1.doubanio.com/img/celebrity/large/11407.jpg"
        }
        
        if let url = NSURL(string : image1){
            iv.sd_setImageWithURL(url)
        }
        conV.addSubview(iv)
        
        let iv2 = UIImageView(frame : CGRectMake(CGRectGetMaxX(iv.frame) + 35, 50, iw, bannerHeight - 50 - 15))
        iv2.contentMode = .ScaleAspectFill
        iv2.clipsToBounds = true
        if let url = NSURL(string : image2){
            iv2.sd_setImageWithURL(url)
        }
        conV.addSubview(iv2)
        
        if let tmp = tableView.dequeueReusableCellWithIdentifier("EventBannersViewController"){
            tmp.removeAllSubViews()
            tmp.addSubview(conV)
            return tmp
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}
