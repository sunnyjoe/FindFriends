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
        let menuWindow = MenuWindow(frame : UIScreen.mainScreen().bounds)
        menuWindow.windowLevel = UIWindowLevelNormal - 1
        
        return menuWindow
    }()
    
    static let sharedInstance = MainViewController()
    
    lazy var tapControl : UIControl = {
        let tapC = UIControl(frame : self.view.bounds)
        tapC.addTapGestureTarget(self, action: #selector(showMenu(_:)))
        return tapC
    }()
    
    var recommendFriends = ConfigDataContainer.sharedInstance.getCachedRecommendFriends()
    let recommendScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        title = "Find Friend"
 
        let chatButton = UIButton(frame : CGRectMake(30, 100, 100 , 40))
       // view.addSubview(chatButton)
        chatButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        chatButton.addTarget(self, action: #selector(gotoChatView), forControlEvents: .TouchUpInside)
        chatButton.setTitle("Chat", forState: .Normal)
        
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
        
        buildRecommendView()
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
        
        let error = EMClient.sharedClient().loginWithUsername("001", password: "001")
        if (error == nil) {
            print("login ok")
        }
    }
    
    func buildRecommendView(){
        recommendScrollView.removeAllSubViews()
        
        var index : CGFloat = 0
        for oneFriend in recommendFriends{
            let card = RecommendCardView(frame : CGRectMake(index * recommendScrollView.frame.size.width, 0, recommendScrollView.frame.size.width, recommendScrollView.frame.size.height), friendInfo : oneFriend)
            recommendScrollView.addSubview(card)
            index += 1
        }
        recommendScrollView.contentSize = CGSizeMake(recommendScrollView.frame.size.width * index, recommendScrollView.frame.size.height)
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
    
    func gotoChatView(){
        let chatVC = ChatViewController(conversationChatter: "002", conversationType: EMConversationTypeChat)
        chatVC.friendName = "002"
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

extension MainViewController : EMContactManagerDelegate {
    func didReceiveFriendInvitationFromUsername(aUsername: String!, message aMessage: String!) {
        UIAlertView.init(title: "Request add friend", message: aMessage, delegate: nil, cancelButtonTitle: "Not Accept").show()
        
    }
}

