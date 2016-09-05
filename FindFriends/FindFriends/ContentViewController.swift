//
//  ContentViewController.swift
//  FindFriends
//
//  Created by jiao qing on 5/9/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    let contactView = UIView()
    let nextBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = .None
        
        view.backgroundColor = UIColor.whiteColor()
        
        title = "Make Friends"

        nextBtn.frame = CGRectMake(50, 100, view.frame.size.width - 50 * 2, 30)
        view.addSubview(nextBtn)
        nextBtn.layer.borderWidth = 1
        nextBtn.layer.borderColor = UIColor.defaultBlack().CGColor
        nextBtn.withTitleColor(UIColor.defaultBlack())
        nextBtn.withTitle("Start make new friends!")
        nextBtn.addTarget(self, action: #selector(seekBtnDidClicked(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
         self.contactView.frame = self.view.bounds
    }
    
    func seekBtnDidClicked(btn : UIButton){
        let disBlock : DismissBlock = {(btnIndex : Int32) -> Void in
            if btnIndex == 0 {
                self.contactView.frame = self.view.bounds
                self.view.addSubview(self.contactView)
                self.buildContactView()
            }
        }
        
        let message = "Please permit us access your access book"
        let alertView = DJAlertView(title: "Dear", message: message, cancelButtonTitle: "Deny", otherButtonTitles: ["Allow"], onDismiss: disBlock, onCancel: {() -> Void in
        })
        alertView.show()
    }
    
    func buildContactView(){
        let alphabetTV = AlphabetTableView(frame : self.contactView.bounds)
        let names = ["Sunny", "A li", "Json", "Micheal Wong", "Mary Liu", "Carollan", "Cathy", "Li Meili", "Ark Joe", "Bake J.M", "Henry Huang", "Xu xian", "White Song", "Mei li duo", "Francis Chang", "Sunny Joe", "Zack Burger", "Cao MeiXu", "Liu Tai Yang", "Malida Nie"]
    
        alphabetTV.setTheContent(names)
        contactView.addSubview(alphabetTV)
        alphabetTV.setContentSelector(self, sel: #selector(didSelectBrandName(_:)))
    }

    func didSelectBrandName(str : String){
        
    }

}
