//
//  ChatViewController.swift
//  FindFriends
//
//  Created by jiao qing on 11/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class ChatViewController: EaseMessageViewController{
    var friendName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = friendName
    }
 

}
