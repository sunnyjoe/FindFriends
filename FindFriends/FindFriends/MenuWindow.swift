//
//  ProfileWindow.swift
//  FindFriends
//
//  Created by jiao qing on 14/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class MenuWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blueColor()
        
        let bgV = UIImageView(frame : bounds)
        addSubview(bgV)
        bgV.image = UIImage(named: "MenuBG")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
