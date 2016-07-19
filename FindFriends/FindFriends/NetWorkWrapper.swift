//
//  NetWorkWrapper.swift
//  FindFriends
//
//  Created by jiao qing on 19/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class NetWorkHandler: NSObject {
    static let sharedInstance = NetWorkHandler()
    
    let httpQueryStringManager = AFHTTPSessionManager(baseURL : NSURL(string: herokuBasicUrl))
    
    lazy var httpJSONManager : AFHTTPSessionManager = {
        let one = AFHTTPSessionManager(baseURL : NSURL(string: herokuBasicUrl))
        one.requestSerializer = AFJSONRequestSerializer()
        return one
    }()
    
    
    func sendNetTask(task : BaseNetTask){
        var httpManager = httpQueryStringManager
        
        if task.method() == HTTPTaskMethod.Post {
            httpManager = httpJSONManager
            
            let files = task.files()
            if files != nil && files!.count > 0{
                
            }else{
                 httpManager.POST(task.uri(), parameters: task.query(), success: task.success, failure: task.failed)
            }
        }else{
            httpManager.GET(task.uri(), parameters: task.query(), success: task.success, failure: task.failed)
        }
        
    }
}
