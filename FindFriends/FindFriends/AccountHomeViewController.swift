//
//  AccountHomeViewController.swift
//  DejaFashion
//
//  Created by jiao qing on 1/3/16.
//  Copyright © 2016 Mozat. All rights reserved.
//

import UIKit

class AccountHomeViewController: BasicViewController {
    let profileView = UIView()
    
    let photoImageView = UIImageView()
    let photoFullImageView = UIImageView()
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    
    let fbView = UIView()
    let fbLabel = UILabel()
    let connectStateLabel = UILabel()
    let arrowIcon = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        title = "Profile"
        profileView.frame = CGRectMake(0, 0, view.frame.size.width, 160)
        view.addSubview(profileView)
        profileView.backgroundColor = UIColor.whiteColor()
        profileView.addSubview(photoImageView)
        profileView.addSubview(nameLabel)
        
        let rightIcon = UIButton(frame: CGRectMake(0, 0, 30, 44))
        rightIcon.setImage(UIImage(named: "SettingIcon"), forState: .Normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightIcon)
        
        photoImageView.layer.cornerRadius = 36
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .ScaleAspectFill
        photoImageView.backgroundColor = UIColor.defaultBlack()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        constrain(photoImageView) { photoImageView in
            photoImageView.top == photoImageView.superview!.top + 40
        }
        NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: nil,attribute: .NotAnAttribute, multiplier: 1, constant: 72).active = true
        NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.Width, relatedBy: .Equal,  toItem: nil,attribute: .NotAnAttribute,  multiplier: 1,  constant: 72).active = true
        
        nameLabel.withTextColor(UIColor.defaultBlack()).withFontHeletica(16)
        nameLabel.textAlignment = .Center
        constrain(nameLabel, photoImageView) { nameLabel, photoImageView in
            nameLabel.top == photoImageView.bottom + 20
            nameLabel.left == nameLabel.superview!.left
            nameLabel.right == nameLabel.superview!.right
        }
        if let url = NSURL(string : "http://hairstylefoto.com/wp-content/uploads/parser/asian-boy-hairstyle-1.jpg"){
            photoImageView.sd_setImageWithURL(url)
        }
        nameLabel.withText("Sunny Bella")
        
        profileView.addBorder()
        
        var oy : CGFloat = 200
        addContactUsLabel(oy)
    }
    
    
    
    func addContactUsLabel(oy : CGFloat) {
        let label = UILabel().withText("Contact Us").withTextColor(DJCommonStyle.BackgroundColor).withFontHeletica(16).textCentered()
        label.frame = CGRectMake(0, oy, view.frame.width, 50)
        view.addSubview(label)
    }
    
}

