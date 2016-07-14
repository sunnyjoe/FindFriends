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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        title = "Find Friend"
        
        //        let error = EMClient.sharedClient().loginWithUsername("001", password: "001")
        //        if (error == nil) {
        //            print("login ok")
        //        }
        
        let chatButton = UIButton(frame : CGRectMake(30, 100, 100 , 40))
        view.addSubview(chatButton)
        chatButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        chatButton.addTarget(self, action: #selector(gotoChatView), forControlEvents: .TouchUpInside)
        chatButton.setTitle("Chat", forState: .Normal)
        //
        //        var newError : EMError?
        //        let userList = EMClient.sharedClient().contactManager.getContactsFromServerWithError(&newError)
        //        print(userList)
        //  EMClient.sharedClient().contactManager.acceptInvitationForUsername("002")
        
        //        EMClient.sharedClient().contactManager.addContact("002", message: "Add Friend")
        //        EMClient.sharedClient().contactManager.addDelegate(self, delegateQueue: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = homeBarItem
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func showProfileView(){
        let mainWindow = UIApplication.sharedApplication().delegate?.window
        if mainWindow == nil {
            return
        }
        if let keyA = mainWindow!!.layer.animationKeys(){
            if keyA.count > 0 {
                return
            }
        }
        
        menuWindow.makeKeyAndVisible()
        
        if mainWindow!!.frame.origin.x != 0{
            UIView.animateWithDuration(0.3, animations: {
                mainWindow!!.frame = UIScreen.mainScreen().bounds
            })
        }else{
            UIView.animateWithDuration(0.3, animations: {
                mainWindow!!.frame = CGRectMake(200, 0, mainWindow!!.frame.size.width, mainWindow!!.frame.size.height)
            })
        }
    }
    
    func gotoChatView(){
        let chatVC = ChatViewController(conversationChatter: "001", conversationType: EMConversationTypeChat)
        chatVC.friendName = "001"
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

extension MainViewController : EMContactManagerDelegate {
    func didReceiveFriendInvitationFromUsername(aUsername: String!, message aMessage: String!) {
        UIAlertView.init(title: "Request add friend", message: aMessage, delegate: nil, cancelButtonTitle: "Not Accept").show()
        
    }
}

