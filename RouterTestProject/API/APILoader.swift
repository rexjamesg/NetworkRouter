//
//  APILoader.swift
//  APITableView_MVVM
//
//  Created by Rex Lin on 2020/7/1.
//  Copyright © 2020 Yu Li Lin. All rights reserved.
//

import UIKit

// 使用方法：
// 1. 建立一個遵循APIProtocal協議的列舉，並定義網域、API路徑、傳送方式以及要下的參數
// 2. 建立對應API格式的model
// 3. 建立一個繼承APILoader的物件來解析對應的model
// 4. 製作一個函式傳入遵循APIProtocal協議的列舉，並下達請求

open class APILoader: NSObject {

    public typealias APICompletion = (_ result:Any?, _ error: String?)->Void
    public typealias RouterCompletion = (_ data:Data?, _ response: URLResponse?, _ error: String?)->Void
        
    //路由器
    let networkRouter:NetworkRouter = NetworkRouter.shared
    
    /**
     指派路由器下答請求並處理回應
     - Parameter api: 遵循APIProtocol協議的類
     */
    public class func sendRequest<T:APIProtocol>(api:T, completion: @escaping RouterCompletion) {
        NetworkRouter.shared.request(api: api) { (data, response, error) in
            
            if error != nil {
                completion(nil, response, NetworkResponse.connectFail.rawValue)
            }
            
            if let response = response as? HTTPURLResponse {
                
                let status = NetworkRouter.shared.handleResponseCode(response)
                
                switch status {
                case .success:
                    
                    guard let responseData = data else {
                        completion(nil, response, NetworkResponse.noData.rawValue)
                        return
                    }
                    
                    completion(responseData, response, nil)
                    
                case .failure(let networFailureError):
                    completion(nil, response, networFailureError)
                }
            }
        }
    }
    
    /**
     將json data直接轉成[String:AnyObject]格式並顯示
     - Parameter data: 回傳的JSON資料
     */
    public class func printJSONData(data:Data) {
        let result = dataToDict(data: data)
        print("printJSONData resultJson:",result ?? "")
    }
    
    public class func dataToDict(data:Data) -> [String:AnyObject]? {
        do {
            let resultJson = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject]
            return resultJson
        } catch {
            print("dataToString error")
            return nil
        }
    }
}
