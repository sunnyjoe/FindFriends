//
//  SettingsViewController.swift
//  DejaFashion
//
//  Created by Sun lin on 28/7/15.
//  Copyright (c) 2015 Mozat. All rights reserved.
//

import UIKit


let kDJPhotoPermissionAlertViewTage = 1342
let kDJSettingsClearCacheAlertViewTag = 1001
let kDJSettingsSignOutAlertViewTag = 1000

class SettingsViewController: BasicViewController
{
    
    private var tableView = UITableView()
    private var cells = [MOTableCellBuilder]()
    private var justClearCache = false
    private let usageLabel = UILabel()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Setting"
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        self.refreshData()
        self.tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), style: UITableViewStyle.Grouped)
        
        self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 70, 0);
        self.tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight;
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor(fromHexString: "e4e4e4")
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        self.view.addSubview(self.tableView)
        
    }
    
    
    func refreshData()
    {
        cells.append(self.buildAboutCell("Customize"))
        cells.append(self.buildAboutCell("Notifications"))
        cells.append(self.buildAboutCell("Privacy"))
        cells.append(self.buildAboutCell("Link Facebook"))
        cells.append(self.buildAboutCell("About us"))
        cells.append(self.buildAboutCell("Log out"))
    }
    
    
    
    func resetCacheUsageLabel(){
        usageLabel.withText("0 MB")
        usageLabel.sizeToFit()
    }
    
    
    
    func buildAboutCell(str : String) -> MOTableCellBuilder
    {
        let cellBuilder = MOTableCellBuilder()
        cellBuilder.height = 55
        let action : (UITableView!, NSIndexPath!) -> Bool = { tableView, indexPath in
            return false
        }
        let view : (UITableView!, NSIndexPath!) -> UITableViewCell! = { tableView, indexPath in
            let cell = self.commonCell(tableView, title: str)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
            return cell;
        }
        cellBuilder.action = action
        cellBuilder.builder = view
        return cellBuilder
    }
    
    
    
    func commonCell(tableView : UITableView, title: String) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        cell.selectedBackgroundView = UIView(frame: cell.bounds)
        cell.selectedBackgroundView!.backgroundColor = UIColor(fromHexString: "f9f9f9")
        cell.textLabel?.text = title
        cell.textLabel?.textColor = UIColor(fromHexString: "414141")
        cell.textLabel?.withFontHeletica(16)
        return cell
    }
    
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return CGFloat(50)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.cells.count
    }
    
    
    // Default is 1 if not implemented
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = self.cells[indexPath.row].builder(tableView, indexPath)
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = DJCommonStyle.DividerColor.CGColor
        return cell
    }
    
    
}
