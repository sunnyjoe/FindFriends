//
//  ConfigDataContainer.swift
//  DejaFashion
//
//  Created by Sun lin on 18/12/15.
//  Copyright © 2015 Mozat. All rights reserved.
//

import Foundation
//import SwiftyJSON
import CoreTelephony



private let FriendsInfoTable = TableWith("FriendsInfoTable", type: FriendInfo.self, primaryKey: "id", dbName: "FriendsInfoTable")


class ConfigDataContainer: NSObject
{
    static let sharedInstance = ConfigDataContainer()
    
    var countryCodeDic : NSDictionary?
    
    
    private override init() {
        super.init()
        
    }
    
    func getMyId() -> String?{
        if let tmp = NSUserDefaults.standardUserDefaults().objectForKey(keyMyOwnUserId) as? String {
            return tmp
        }
        return nil
    }
    
    func getMyInfo(handler : (FriendInfo?) -> Void){
        if let myId = getMyId(){
            getFriendInfoById(myId, handler)
        }else{
            handler(nil)
        }
    }
    
    func resetUserId(id : String?){
        if id == nil {
            NSUserDefaults.standardUserDefaults().setObject(id, forKey: keyMyOwnUserId)
        }else{
            NSUserDefaults.standardUserDefaults().removeObjectForKey(keyMyOwnUserId)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getFriendInfoById(id : String, _ handler : (FriendInfo?) -> Void){
        let handlerWarpper = {(info : FriendInfo?) -> Void in
            if info != nil {
                handler(info)
            }else{
                //send nettask
                let fake1 = FriendInfo()
                fake1.name = "Sunny Jiao"
                fake1.careerInfo = "Supply Chain"
                fake1.isFemale = true
                fake1.imageUrl = "http://hairstylefoto.com/wp-content/uploads/parser/asian-boy-hairstyle-1.jpg"
                handler(fake1)
            }
        }
        getCachedFriendInfoById(id, handlerWarpper)
    }
    
    func getCachedFriendInfoById(id : String, _ handler : (FriendInfo?) -> Void){
        let handlerWarpper = {(infos : [FriendInfo]) -> Void in
            if infos.count > 0 {
                handler(infos[0])
            }else{
                handler(nil)
            }
        }
        FriendsInfoTable.query(["id"], values: [id], handler : handlerWarpper)
    }
    
    func getCachedRecommendFriends(handler : ([FriendInfo]) -> Void){
        let cahcedRecommendIds : [String] = getCachedRecomendFriendsId()
        
        FriendsInfoTable.query(["id"], values: cahcedRecommendIds, handler : handler)
    }
    
    func getCachedRecomendFriendsId() -> [String] {
        if let tmp = NSUserDefaults.standardUserDefaults().objectForKey(keyCachedRecomendFriendsId) as? [String] {
            return tmp
        }
        return [String]()
    }
    
    func updateCachedRecomendFriendsId(ids : [String]) {
        NSUserDefaults.standardUserDefaults().setObject(ids, forKey: keyCachedRecomendFriendsId)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getCountryCodeDic() -> NSDictionary{
        if countryCodeDic == nil{
            countryCodeDic = NSDictionary()
            if let plistPath = NSBundle.mainBundle().pathForResource("Countries", ofType: "plist") {
                if let orgData = NSDictionary(contentsOfFile: plistPath) {
                    countryCodeDic = orgData
                }
            }
        }
        return countryCodeDic!
    }
    
    
    func getCurrentCountryCallingCode() -> String?{
        let network_Info =  CTTelephonyNetworkInfo()
        let carrier = network_Info.subscriberCellularProvider
        if carrier == nil {
            return nil
        }
        let countryCode = carrier!.isoCountryCode
        if countryCode == nil {
            return nil
        }
        
        let ccd = getCountryCodeDic()
        let orgKeys = ccd.allKeys as! [String]
        
        for oneKey in orgKeys {
            if oneKey.uppercaseString == countryCode?.uppercaseString {
                let dic = ccd[oneKey] as! NSDictionary
                return String(dic["CountryCallingCode"]!)
            }
        }
        7
        return nil
    }
    
    func getLengthOfPhoneNumByCountryCode(code : String) -> (Int, Int) {
        let ccd = getCountryCodeDic()
        let orgKeys = ccd.allKeys as? [String]
        if orgKeys == nil{
            return (0,20)
        }
        for oneKey in orgKeys! {
            let dic = ccd[oneKey] as? NSDictionary
            if dic == nil{
                continue
            }
            let cc = dic!["CountryCallingCode"]
            if cc == nil {
                continue
            }
            if String(cc!) == code {
                let vv = dic!["PhoneNumberLength"] as? String
                if vv == nil{
                    return (0,20)
                }
                let lenar = vv!.componentsSeparatedByString(",")
                if lenar.count == 1{
                    let oneT = lenar[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if oneT.characters.count > 0{
                        if let tmp = Int(oneT){
                            return (tmp, tmp)
                        }
                    }
                }else if lenar.count > 1{
                    var numberV = [Int]()
                    for stL in lenar{
                        let oneT = stL.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        if oneT.characters.count > 0{
                            if let tmp = Int(oneT){
                                numberV.append(tmp)
                            }
                        }
                    }
                    if numberV.count == 0{
                        return (0,20)
                    }else if numberV.count == 1{
                        return (numberV[0], numberV[0])
                    }
                    var smallest = 100
                    var biggest = 0
                    for rn in numberV{
                        if rn < smallest{
                            smallest = rn
                        }
                        if rn > biggest{
                            biggest = rn
                        }
                    }
                    return (smallest, biggest)
                }
                break
            }
        }
        
        return (0,20)
    }
    
}













