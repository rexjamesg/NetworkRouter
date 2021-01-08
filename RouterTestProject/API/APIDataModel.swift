//
//  APIDataModel.swift
//  RouterTestProject
//
//  Created by Rex Lin on 2020/7/2.
//  Copyright © 2020 Rex. All rights reserved.
//

import UIKit

///API名稱列舉，方便呼叫，可擴充
enum APIDataModel:APIProtocol {
    case randomUser(gender:String?=nil)
    case getIpDetail(ip:String)
}

extension APIDataModel {
    ///API的網域
    var domain: String {
        switch self {
        case .randomUser:
            return "https://randomuser.me"
        case .getIpDetail:
            return "https://api.iplegit.com"
        }
    }
    
    ///API的完整網址
    var url: URL {
        guard let url = URL(string: domain+path) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }

    ///API的路徑
    var path: String {
        switch self {
        case .randomUser:
            return "/api/"
        case .getIpDetail:
            return "/full"
        }
    }
    
    /**
     可根據需求切換或新增方式
     GET、HEAD、POST、PUT、DELETE...
     */
    var httpMethod: HTTPMethod {
        switch self {
        case .randomUser:
            return .get
        case .getIpDetail:
            return .get
        }
    }
    
    /**
     根據API使用對應的傳送方式，例如formData等...
     */
    var task: HTTPTask {
        switch self {
        case .randomUser(let gender):
            return .requestUrlParameters(parameters: ["gender":gender ?? ""])
        case .getIpDetail(let ip):
            return .requestUrlParameters(parameters: ["ip":ip])
        }
    }
    
    ///若有每支API都需傳送的值可寫在這裡，例如APIKey
    var commonParameter: [String : Any]? {
        return nil
    }
}
