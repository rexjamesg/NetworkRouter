//
//  APIManager.swift
//  RouterTestProject
//
//  Created by Rex Lin on 2020/7/2.
//  Copyright © 2020 Rex. All rights reserved.
//

import UIKit

class APIManager: APILoader {
    
    public typealias APICompletion = (_ result:Any?, _ error: String?)->Void
    
    class func sendAPI(api:APISourceModel, completion:(APICompletion)?=nil) {
        sendRequest(api: api) { (responseData, response, error) in
            if let completion = completion {
                                                
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let data = responseData {
                    let result = checkResult(api: api, responseData: data)
                    completion(result,"nil")
                } else {
                    completion(nil,"Data is empty")
                }
            }
        }
    }
    
    /**
     處理與解析API內容
     - Parameter api: API
     - Parameter responseData: 傳回來的資料
     - Returns: （資料, 錯誤資訊)
     */
    private class func checkResult(api:APISourceModel, responseData:Data) -> Any? {
        do {
            switch api {
            case .getIpDetail:
                let result = try JSONDecoder().decode(IpDetail.self, from: responseData)
                return result
                
            case .randomUser:
                let result = try JSONDecoder().decode(RandomUser.self, from: responseData)
                return result
            }
        } catch {
            return NetworkResponse.unableToDecode.rawValue
        }
    }
    
    
}
