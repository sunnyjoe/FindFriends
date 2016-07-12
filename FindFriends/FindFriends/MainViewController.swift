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
 
        let error = EMClient.sharedClient().loginWithUsername("002", password: "002")
        if (error == nil) {
            print("login ok")
        }
        
        let chatButton = UIButton(frame : CGRectMake(30, 100, 100 , 40))
        view.addSubview(chatButton)
        chatButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        chatButton.addTarget(self, action: #selector(gotoChatView), forControlEvents: .TouchUpInside)
        chatButton.setTitle("Chat", forState: .Normal)
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            return
        }
        
        self.navigationController?.navigationBarHidden = true
    }
    
    func gotoChatView(){
      //  let chatVC = ChatViewController(conversationChatter: "002", conversationType: EMConversationTypeChat)
      //  self.navigationController?.pushViewController(chatVC, animated: true)
    }

}

