//
//  ChatViewController.swift
//  FindFriends
//
//  Created by jiao qing on 11/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, IChatManagerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
    }

 
}
