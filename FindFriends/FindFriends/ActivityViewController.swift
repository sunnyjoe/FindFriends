//
//  ActivityViewController.swift
//  FindFriends
//
//  Created by Jiao on 24/9/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import Foundation

class ActivityViewController: BasicViewController, UITableViewDataSource, UITableViewDelegate{
    private let tableView = UITableView()
    let bannerHeight : CGFloat = 236
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Activities"
        
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
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
        
        let narLabel = UILabel(frame : CGRectMake(23, 0, view.frame.size.width - 23 * 2, 37))
        narLabel.withTextColor(UIColor.defaultBlack())
        narLabel.withText("How about a movie?").withFontHeletica(16)
        narLabel.backgroundColor = UIColor(fromHexString: "fafafa")
        conV.addSubview(narLabel)
        
        if indexPath.row == 1 {
            narLabel.withText("How about eat together?")
        }
        
        if indexPath.row == 2 {
            narLabel.withText("How about talking in a park")
        }
        
        let border = UIImageView(frame : CGRectMake(23, 37, view.frame.size.width - 23 * 2, 1))
        border.backgroundColor = UIColor.lightGrayColor()
        conV.addSubview(border)
        
        let iw = (view.frame.size.width - 23 * 2)
        
        let iv = UIImageView(frame : CGRectMake(23, 50, iw, bannerHeight - 23 * 2 - 10))
        iv.contentMode = .ScaleAspectFill
        iv.clipsToBounds = true
        
        var image1 = "http://img02.tooopen.com/images/20150819/tooopen_sy_139033156896.jpg"
        if indexPath.row == 1 {
            image1 = "http://mmbiz.qpic.cn/mmbiz/vQCGoQzHAbZSRIGnickly191BprheAeiadwhF7TibfvPCEMibdVeqYuWVDX4jk0te2qiczfpYlD1yatRa8qxicO7Gw8Q/0?/1.jpg"
        }else if indexPath.row == 2 {
            image1 = "https://upload.wikimedia.org/wikipedia/commons/b/bb/%E5%A4%9A%E6%91%A9%E5%B7%9D%E7%B7%91%E5%9C%B0%E7%A6%8F%E7%94%9F%E5%8D%97%E5%85%AC%E5%9C%92.JPG"
        }
        
        if let url = NSURL(string : image1){
            iv.sd_setImageWithURL(url)
        }
        conV.addSubview(iv)
        
        
        if let tmp = tableView.dequeueReusableCellWithIdentifier("UITableViewCell"){
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
