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


class ConfigDataContainer: NSObject
{
    static let sharedInstance = ConfigDataContainer()
    
    var countryCodeDic : NSDictionary?
    
    
    private override init() {
        super.init()
        
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













