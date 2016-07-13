//
//  MainViewController.swift
//  FindFriends
//
//  Created by jiao qing on 11/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    func gotoChatView(){
        let chatVC = ChatViewController(conversationChatter: "002", conversationType: EMConversationTypeChat)
        chatVC.friendName = "002"
        self.navigationController?.pushViewController(chatVC, animated: true)
    }

}

