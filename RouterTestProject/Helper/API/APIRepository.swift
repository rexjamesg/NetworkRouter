//
//  APIRepository.swift
//  RouterTestProject
//
//  Created by Rex Lin on 2021/4/12.
//  Copyright © 2021 Rex. All rights reserved.
//

import UIKit

class APIRepository: NSObject {
    
    class func getRandomUser(gender:String, completeHandler: ((_ result:String)->Void)?=nil) {
        APIManager.sendAPI(api: .randomUser(gender: gender)) { (result, error) in
            if let result = result as? RandomUser {
                if let text = result.convertToDict()?.description {
                    if completeHandler != nil {
                        completeHandler!(text)
                    }
                }
            }
        }
    }
    
    class func getIpDetail(ip:String, completeHandler: ((_ result:String)->Void)?=nil) {
        APIManager.sendAPI(api: .getIpDetail(ip: ip))  { (result, error) in
            if let result = result as? IpDetail {
                if let text = result.convertToDict()?.description {
                    if completeHandler != nil {
                        completeHandler!(text)
                    }
                }
            }
        }
    }

}
