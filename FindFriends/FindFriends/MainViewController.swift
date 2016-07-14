//
//  MainViewController.swift
//  FindFriends
//
//  Created by jiao qing on 11/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class MainViewController: BasicViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
 
        let error = EMClient.sharedClient().loginWithUsername("001", password: "001")
        if (error == nil) {
            print("login ok")
        }
        
        let chatButton = UIButton(frame : CGRectMake(30, 100, 100 , 40))
        view.addSubview(chatButton)
        chatButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        chatButton.addTarget(self, action: #selector(gotoChatView), forControlEvents: .TouchUpInside)
        chatButton.setTitle("Chat", forState: .Normal)
        
        var newError : EMError?
        let userList = EMClient.sharedClient().contactManager.getContactsFromServerWithError(&newError)
        print(userList)
      //  EMClient.sharedClient().contactManager.acceptInvitationForUsername("002")
        
//        EMClient.sharedClient().contactManager.addContact("002", message: "Add Friend")
//        EMClient.sharedClient().contactManager.addDelegate(self, delegateQueue: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
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

