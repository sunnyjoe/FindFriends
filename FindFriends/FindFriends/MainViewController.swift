//
//  MainViewController.swift
//  FindFriends
//
//  Created by jiao qing on 11/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class MainViewController: BasicViewController {
    private lazy var homeBarItem : UIBarButtonItem = {
        let btn = UIButton.init(type: .Custom)
        btn.setImage(UIImage(named: "MenuIcon"), forState: .Normal)
        btn.frame = CGRectMake(44, 11.5, 23, 21)
        btn.addTarget(self, action: #selector(showProfileView), forControlEvents: .TouchUpInside)
        
        return UIBarButtonItem(customView : btn)
    }()
    
    private lazy var menuWindow : MenuWindow = {
        let menuWindow = MenuWindow(frame : CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - showMenuMainViewRemain, UIScreen.mainScreen().bounds.size.height))
        menuWindow.windowLevel = UIWindowLevelNormal - 1
        
        return menuWindow
    }()
    
    static let sharedInstance = MainViewController()
    
    lazy var tapControl : UIControl = {
        let tapC = UIControl(frame : self.view.bounds)
        tapC.addTapGestureTarget(self, action: #selector(showMenu(_:)))
        return tapC
    }()
    
    var recommendFriends = [FriendInfo]()
    let recommendScrollView = UIScrollView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        ConfigDataContainer.sharedInstance.getCachedRecommendFriends({(recFriends : [FriendInfo]) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.recommendFriends = recFriends
                
                let fake1 = FriendInfo()
                fake1.name = "Sunny Jiao"
                fake1.careerInfo = "Supply Chain"
                fake1.isFemale = true
             //   fake1.imageUrl = "http://beauty.pclady.com.cn/sszr/0601/pic/20060117_bb_9.jpg"
                
                
                self.recommendFriends = [fake1, fake1]
                self.buildRecommendView()
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        title = "Find Friend"
//        
//        let chatButton = UIButton(frame : CGRectMake(30, 100, 100 , 40))
//        // view.addSubview(chatButton)
//        chatButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
//        chatButton.addTarget(self, action: #selector(gotoChatView), forControlEvents: .TouchUpInside)
//        chatButton.setTitle("Chat", forState: .Normal)
        
        //        var newError : EMError?
        //        let userList = EMClient.sharedClient().contactManager.getContactsFromServerWithError(&newError)
        //        print(userList)
        //  EMClient.sharedClient().contactManager.acceptInvitationForUsername("002")
        
        //        EMClient.sharedClient().contactManager.addContact("002", message: "Add Friend")
        //        EMClient.sharedClient().contactManager.addDelegate(self, delegateQueue: nil)
        
        recommendScrollView.frame = CGRectMake(0, 0, view.frame.size.width, UIScreen.mainScreen().bounds.size.height - 64 - 150)
        view.addSubview(recommendScrollView)
        recommendScrollView.showsHorizontalScrollIndicator = false
        recommendScrollView.pagingEnabled = true
        
        self.buildRecommendView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = homeBarItem
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func buildRecommendView(){
        recommendScrollView.removeAllSubViews()
        
        var index : CGFloat = 0
        for oneFriend in recommendFriends{
            let card = RecommendCardView(frame : CGRectMake(index * recommendScrollView.frame.size.width, 0, recommendScrollView.frame.size.width, recommendScrollView.frame.size.height), friendInfo : oneFriend)
            recommendScrollView.addSubview(card)
            card.delegate = self
            index += 1
        }
        recommendScrollView.contentSize = CGSizeMake(recommendScrollView.frame.size.width * index, recommendScrollView.frame.size.height)
    }
}

extension MainViewController : EMContactManagerDelegate, RecommendCardViewDelegate {
    func recommendCardViewDidClickSay(recommendCardView: RecommendCardView) {
//        let chatVC = ChatViewController(conversationChatter: "002", conversationType: EMConversationTypeChat)
//        chatVC.friendName = "002"
//        self.navigationController?.pushViewController(chatVC, animated: true)
        
        let one = TestNetTask()
        one.success = {(task : NSURLSessionDataTask, responseObject : AnyObject?) -> Void in
            do {
                let data = responseObject as! NSData
                let jsonObject = NSString(data: data, encoding: NSUTF8StringEncoding)
                 print("json: \(jsonObject)")
                // use jsonObject here
            } catch {
                print("json error")
            }
            
        }
        one.failed = {(task : NSURLSessionDataTask?, error : NSError) -> Void in
                print("failed")
                print(error.description)
        }
        
        NetWorkHandler.sharedInstance.sendNetTask(one)
    }
    
    func didReceiveFriendInvitationFromUsername(aUsername: String!, message aMessage: String!) {
        UIAlertView.init(title: "Request add friend", message: aMessage, delegate: nil, cancelButtonTitle: "Not Accept").show()
        
    }
    
    func showProfileView(){
        let mainWindow = UIApplication.sharedApplication().delegate?.window!!
        if mainWindow!.frame.origin.x != 0{
            showMenu(false)
        }else{
            showMenu(true)
        }
    }
    
    func showMenu(show : Bool){
        let mainWindow = UIApplication.sharedApplication().delegate?.window!
        if let keyA = mainWindow!.layer.animationKeys(){
            if keyA.count > 0 {
                return
            }
        }
        menuWindow.makeKeyAndVisible()
        if show {
            UIView.animateWithDuration(0.3, animations: {
                mainWindow!.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width - showMenuMainViewRemain, 0, mainWindow!.frame.size.width, mainWindow!.frame.size.height)
            })
            view.addSubview(tapControl)
        }else{
            UIView.animateWithDuration(0.3, animations: {
                mainWindow!.frame = UIScreen.mainScreen().bounds
            })
            tapControl.removeFromSuperview()
        }
    }
    
}

