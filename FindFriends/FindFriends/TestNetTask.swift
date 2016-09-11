//
//  TestNetTask.swift
//  FindFriends
//
//  Created by Jiao on 5/8/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class TestNetTask: BaseNetTask {
    override func uri() -> String!
    {
        return "search"
    }
    
    override func method() -> HTTPTaskMethod
    {
        return HTTPTaskMethod.Get
    }
}
