//
//  ProfileEditViewController.swift
//  FindFriends
//
//  Created by jiao qing on 5/9/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController, ZESegmentedsViewDelegate {
    let firstView = UIView()
    let secondView = UIView()
    
    let addPhoto = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(firstView)
        firstView.backgroundColor = UIColor.whiteColor()
        firstView.frame = view.bounds
        buildFirstView(firstView)
        
        secondView.hidden = true
        secondView.backgroundColor = UIColor.whiteColor()
        view.addSubview(secondView)
        secondView.frame = view.bounds
        buildSecondView(secondView)
    }
    
    func buildFirstView(conv : UIView){
        let width = view.frame.size.width * 0.25
        addPhoto.frame = CGRectMake(15, 80, width, width)
        conv.addSubview(addPhoto)
        addPhoto.clipsToBounds = true
        addPhoto.layer.cornerRadius = width / 2
        addPhoto.layer.borderWidth = 0.75
        addPhoto.layer.borderColor = UIColor.lightGrayColor().CGColor
        addPhoto.contentHorizontalAlignment = .Center
        addPhoto.setBackgroundColor(UIColor.lightGrayColor(), forState: .Normal)
        addPhoto.setImage(UIImage(named: "CameraAgainNormal"), forState: .Normal)
        addPhoto.contentMode = .Center
        
        
        var oy = addPhoto.frame.origin.y - 10
        var ox = CGRectGetMaxX(addPhoto.frame) + 10
        buildFakeLabel(CGPointMake(ox, oy), text: "Name", placeHolder: "Input", conv: conv)
        
        oy += 30 + 10
        buildFakeSelect(CGRectMake(ox, oy, 50, 30), title: "Gender", frame: CGRectMake(ox + 50 + 10, oy, min(conv.frame.size.width - ox - 50 - 10 - 20, 130), 30), text: "Female", conv: conv)
        oy += 30 + 10
        buildFakeLabel(CGPointMake(ox, oy), text: "Brithday", placeHolder: "10/17", conv: conv)
        
        ox = 45
        oy += 30 + 50
        buildFakeSelect(CGRectMake(ox, oy, 100, 30), title: "Age", frame: CGRectMake(ox + 100 + 10, oy, min(conv.frame.size.width - ox - 100 - 10 - 20, 130), 30), text: "20 - 25", conv: conv)
        
        oy += 30 + 15
        buildFakeSelect(CGRectMake(ox, oy, 100, 30), title: "Live in", frame: CGRectMake(ox + 100 + 10, oy, min(conv.frame.size.width - ox - 100 - 10 - 20, 130), 30), text: "Singapore", conv: conv)
        oy += 30 + 15
        buildFakeSelect(CGRectMake(ox, oy, 100, 30), title: "University", frame: CGRectMake(ox + 100 + 10, oy, min(conv.frame.size.width - ox - 100 - 10 - 20, 130), 30), text: "NTU", conv: conv)
        oy += 30 + 15
        buildFakeSelect(CGRectMake(ox, oy, 100, 30), title: "Status", frame: CGRectMake(ox + 100 + 10, oy, min(conv.frame.size.width - ox - 100 - 10 - 20, 130), 30), text: "Available", conv: conv)
        
        oy += 30 + 35
        
        let nextBtn = UIButton(frame : CGRectMake(50, conv.frame.size.height - 100, view.frame.size.width - 50 * 2, 30))
        conv.addSubview(nextBtn)
        nextBtn.layer.borderWidth = 1
        nextBtn.layer.borderColor = UIColor.defaultBlack().CGColor
        nextBtn.withTitleColor(UIColor.defaultBlack())
        nextBtn.withTitle("Continue")
        nextBtn.addTarget(self, action: #selector(nextBtnDidClicked(_:)), forControlEvents: .TouchUpInside)
    }
    
    func buildFakeLabel(origi: CGPoint, text : String, placeHolder: String, conv : UIView){
        let birhLabel = UILabel(frame: CGRectMake(origi.x, origi.y, 85, 30))
        birhLabel.withText(text).withFontHeletica(15).withTextColor(UIColor.defaultBlack())
        conv.addSubview(birhLabel)
        
        let birtf = UITextField(frame: CGRectMake(CGRectGetMaxX(birhLabel.frame), birhLabel.frame.origin.y, 80, birhLabel.frame.size.height))
        conv.addSubview(birtf)
        birtf.addBorder()
        birtf.enabled = false
        birtf.placeholder = placeHolder
    }
    
    func buildFakeSelect(titleFrame: CGRect, title: String, frame : CGRect, text : String, conv : UIView) -> UIView{
        let gengerL = UILabel(frame: titleFrame)
        gengerL.withText(title).withFontHeletica(15).withTextColor(UIColor.defaultBlack())
        conv.addSubview(gengerL)
        
        let inputL = UILabel(frame: CGRectMake(frame.origin.x, frame.origin.y, frame.size.width - 6.5 - 15, frame.size.height))
        inputL.withText(text).withFontHeletica(15).withTextColor(UIColor.defaultBlack()).textCentered()
        inputL.layer.borderWidth = 1
        inputL.layer.borderColor = UIColor.defaultBlack().CGColor
        conv.addSubview(inputL)
        
        let arrow = UIImageView(frame: CGRectMake(CGRectGetMaxX(inputL.frame) - 1, frame.origin.y, 6.5 + 15, frame.size.height))
        arrow.contentMode = .Center
        //arrow.image = UIImage(named: "TutorialArrowDown")
        conv.addSubview(arrow)
        arrow.layer.borderWidth = 1
        arrow.layer.borderColor = UIColor.defaultBlack().CGColor
        return inputL
    }
    
    func buildSecondView(conv : UIView){
        let backBtn = UIButton(frame : CGRectMake(0, 30, 80, 30))
        conv.addSubview(backBtn)
        backBtn.withTitleColor(UIColor.defaultBlack())
        backBtn.withTitle("back").withFontHeletica(15)
        backBtn.addTarget(self, action: #selector(backBtnDidClicked(_:)), forControlEvents: .TouchUpInside)
        
        let infoL = UILabel(frame: CGRectMake(20, 80, 100, 30))
        infoL.withText("Interests").withFontHeletica(16).withTextColor(UIColor.defaultBlack())
        conv.addSubview(infoL)
        
        let firstArray = ["Design", "Reading", "Travel", "Fashion", "Cooking"]
        ZESegmentedsViewSingleton.shareManager().showSementedViewWithTarget(self, containerView: secondView, frame: CGRectMake(20, 120, conv.frame.size.width - 20 * 2, 35), sementedCount: firstArray.count, sementedTitles: firstArray)
        
        let secondArray = ["Dance", "Drawing", "Cosplay", "Digital", "Coffee"]
        ZESegmentedsViewSingleton.shareManager().showSementedViewWithTarget(self, containerView: secondView, frame: CGRectMake(20, 170, conv.frame.size.width - 20 * 2, 35), sementedCount: secondArray.count, sementedTitles: secondArray)
        
        let thirdArray = ["Air Sports", "Baseball", "Crocheting", "Computer"]
        ZESegmentedsViewSingleton.shareManager().showSementedViewWithTarget(self, containerView: secondView, frame: CGRectMake(20, 220, conv.frame.size.width - 20 * 2, 35), sementedCount: thirdArray.count, sementedTitles: thirdArray)
        
        let forthArray = ["Topiary", "Skiingng", "Shooting", "Skydiving"]
        ZESegmentedsViewSingleton.shareManager().showSementedViewWithTarget(self, containerView: secondView, frame: CGRectMake(20, 270, conv.frame.size.width - 20 * 2, 35), sementedCount: forthArray.count, sementedTitles: forthArray)
        
        let fivethArray = ["Ice skating", "Juggling", "Knapping"]
        ZESegmentedsViewSingleton.shareManager().showSementedViewWithTarget(self, containerView: secondView, frame: CGRectMake(20, 320, conv.frame.size.width - 20 * 2, 35), sementedCount: fivethArray.count, sementedTitles: fivethArray)
        
        let nextBtn = UIButton(frame : CGRectMake(50, conv.frame.size.height - 100, conv.frame.size.width - 50 * 2, 30))
        conv.addSubview(nextBtn)
        nextBtn.layer.borderWidth = 1
        nextBtn.layer.borderColor = UIColor.defaultBlack().CGColor
        nextBtn.withTitleColor(UIColor.defaultBlack())
        nextBtn.withTitle("Finish")
        nextBtn.addTarget(self, action: #selector(finishDidClicked(_:)), forControlEvents: .TouchUpInside)
    }
    
    func backBtnDidClicked(btn : UIButton){
        UIView.animateWithDuration(0.3, animations: {
            self.secondView.alpha = 0
            self.firstView.alpha = 1
            }, completion: {(Bool) -> Void in
                self.secondView.hidden = true
        })
    }
    
    func finishDidClicked(btn : UIButton){
        presentViewController(UINavigationController(rootViewController: MainViewController.sharedInstance), animated: true, completion: nil)
    }
    
    func nextBtnDidClicked(btn : UIButton){
        secondView.hidden = true
        UIView.animateWithDuration(0.3, animations: {
            self.firstView.alpha = 0
            self.secondView.alpha = 1
            }, completion: {(Bool) -> Void in
                self.secondView.hidden = false
        })
    }
    
    func selectedZESegmentedsViewItemAtIndex(selectedItemIndex: Int) {
        
    }
}

