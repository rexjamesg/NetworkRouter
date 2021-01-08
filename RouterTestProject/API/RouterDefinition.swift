//
//  RouterDefinition.swift
//  APITableView_MVVM
//
//  Created by Rex Lin on 2020/7/2.
//  Copyright © 2020 Yu Li Lin. All rights reserved.
//

import UIKit

///API協議
public protocol APIProtocol {
    var domain:String { get }
    var url:URL { get }
    var path:String { get }
    var httpMethod:HTTPMethod { get }
    var task:HTTPTask { get }
    var commonParameter:[String:Any]? { get }
}

///定義Header格式
public typealias HTTPHeaders = [String:String]
///定義參數格式
public typealias Parameters = [String:Any]
///定義路由閉包
public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->Void


/**
回應結果(成功或失敗)
````
case success
case failure(String)
````
*/
public enum ResponseResult<String> {
    case success
    case failure(String)
}


/**
回應訊息
````
case authenticationError
case badRequest
case outdated
case failed
case noData
case unableToDecode
case connectFail
````
*/
public enum NetworkResponse:String {
    ///請求未授權
    case authenticationError    = "You need to be authenticated first."
    ///請求錯誤(可能下的參數有問題)
    case badRequest             = "Bad request."
    ///請求過期
    case outdated               = "The url you requested is outdated."
    ///請求失敗
    case failed                 = "Network request failed"
    ///無回應資料
    case noData                 = "Response returned with no data to decode"
    ///無法解析資料(回傳格式不是JSON)
    case unableToDecode         = "We could not decode the response"
    ///連線失敗(網路有問題)
    case connectFail            = "Please check your network connection"
}

/**
Service
````
參數加入至httpBody
case requestBodyParameters(parameters:Parameters?)
 
參數加入至網址後方
case requestUrlParameters(parameters:Parameters?)
 
參數由formdata方式傳送(可傳送圖片)
case requestFormdataParameter(parameters:Parameters?)
 
參數及header加入至httpBody
case requestBodyParametersAndHeaders(parameters:Parameters?, additionHeaders:HTTPHeaders)
 
參數加入至網址後方以及加入header
case requestUrlParametersAndHeaders(parameters:Parameters?, additionHeaders:HTTPHeaders)
 
參數formdata方式傳送(可傳送圖片)以及加入header
case requestFormdataParametersAndHeaders(parameters:Parameters?, additionHeaders:HTTPHeaders)
````
*/
public enum HTTPTask {
    ///參數加入至httpBody
    case requestBodyParameters(parameters:Parameters?)
    ///參數加入至網址後方
    case requestUrlParameters(parameters:Parameters?)
    ///參數由formdata方式傳送(可傳送圖片)
    case requestFormdataParameter(parameters:Parameters?)
    ///參數及header加入至httpBody
    case requestBodyParametersAndHeaders(parameters:Parameters?, additionHeaders:HTTPHeaders)
    ///參數加入至網址後方以及加入header
    case requestUrlParametersAndHeaders(parameters:Parameters?, additionHeaders:HTTPHeaders)
    ///參數formdata方式傳送(可傳送圖片)以及加入header
    case requestFormdataParametersAndHeaders(parameters:Parameters?, additionHeaders:HTTPHeaders)
}

///HTTP方法(目前只列出常用的兩種，可擴充)
public enum HTTPMethod:String {
    case get    = "GET"
    case post   = "POST"
}

///網路層傳輸錯誤訊息
public enum NetworkError:String, Error {
    case encodeFail = "Parameter encodingFail"
    case missingURL = "URL is nil"
}

internal extension NSMutableData {
    ///將參數相加(formdata使用)
    func appendString(_ string: String) {
        if let data = string.data(using: String.Encoding.utf8) {
            append(data)
        }
    }
}

internal extension URLComponents {
    ///將多個參數轉成網址後方參數 (urlRequest使用)
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
