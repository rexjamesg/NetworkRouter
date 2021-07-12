//
//  NetWorkManager.swift
//  APITableView_MVVM
//
//  Created by Yu Li Lin on 2020/1/6.
//  Copyright © 2020 Yu Li Lin. All rights reserved.
//

import UIKit

final class NetworkRouter: NSObject {
    
    static let shared:NetworkRouter = NetworkRouter()
    private var task:URLSessionTask?
    
    /**
     下達請求
     - Parameter api:遵循APIProtocol協議的類
     */
    public func request<T:APIProtocol>(api: T, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try buildRequest(api: api)
            print("request",request)
            
            task = session.dataTask(with: request) {(data, response, error) in
                completion(data, response, error)
            }
            task?.resume()
        } catch {
            completion(nil, nil, error)
        }
    }
    
    /**
     建立請求
     - parameter api: 遵循APIProtocol協議的類
    */
    private func buildRequest<T:APIProtocol>(api: T) throws -> URLRequest {
        
        var request = URLRequest.init(url: api.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
        request.httpMethod = api.httpMethod.rawValue
                       
        switch api.task {
        
        case .requestBodyParameters(let parameters, let additionHeaders):
            let fullParameters = appendCommonParameters(api: api, parameters: parameters)
            addAdditionalHeaders(additionHeaders, request: &request)
            try configureParameters(bodyParameters: fullParameters, request: &request)
                        
        case .requestFormdataParameters(let parameters, let additionHeaders):
            let fullParameters = appendCommonParameters(api: api, parameters: parameters)
            addAdditionalHeaders(additionHeaders, request: &request)
            try configureParameters(formdataParameter: fullParameters, request: &request)
            
        case .requestUrlParameters(let parameters, let additionHeaders):
            let fullParameters = appendCommonParameters(api: api, parameters: parameters)
            addAdditionalHeaders(additionHeaders, request: &request)
            try configureParameters(urlParameters: fullParameters, request: &request)
            
        }
        
        return request
    }
    
    /**
     加入API固定的參數
     - Parameter api:遵循APIProtocol協議的類
     - Parameter parameters: 要傳送的參數
    */
    private func appendCommonParameters<T:APIProtocol>(api:T, parameters:Parameters?) -> Parameters? {
        //取得API固定的參數
        if var commonParameter = api.commonParameter {
            var originParameters:Parameters = [:]
            if parameters != nil {
                originParameters = parameters!
            }
            commonParameter.merge(originParameters) { (_, second) in second }
            return commonParameter
        }
        
        return parameters
    }
    
    /**
     設定請求參數
     - Parameter bodyParameters: 塞在http body裡面的參數
     - Parameter urlParameters: 塞在網址後面的參數
     */
    private func configureParameters(bodyParameters:Parameters?=nil, urlParameters:Parameters?=nil, formdataParameter:Parameters?=nil, request: inout URLRequest) throws {
        
        do {
            if let bodyParameters = bodyParameters {
                try jsonEncode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try urlParameterEncode(urlRequest: &request, with: urlParameters)
            }
            
            if let formdataParameter = formdataParameter {
                try bounderyEncode(urlRequest: &request, with: formdataParameter)
            }
            
        } catch {
            throw error
        }
    }
        
    /**
     以JSON格式傳遞參數
     - Parameter urlRequest: 請求
     - Parameter parameters: 參數
     */
    private func jsonEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
                        
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = jsonData
            
        } catch {
            throw NetworkError.encodeFail
        }
    }
    
    
    /**
     以formData格式傳遞參數
     - Parameter urlRequest: 請求
     - Parameter parameters: 參數
     */
    private func bounderyEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        //boundary可自定義
        let boundary:String = "=========="
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition:form-data; name='\(key)'\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString("--\(boundary)--")
        urlRequest.httpBody = body as Data        
    }
    
    /**
     以網址傳遞參數 (ex: https://www.xxx.xxx?keyA=valueA&keyB=valueB)
     - Parameter urlRequest: 請求
     - Parameter parameters: 參數
     */
    private func urlParameterEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        if var urlComponents = URLComponents.init(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            var queryItems:[URLQueryItem] = []
            for (key,value) in parameters {
                let queryItem = URLQueryItem.init(name: key, value: "\(value)")
                //若再加入addingPercentEncoding會造成2次轉碼，
                //網址有中文會出問題
                //let queryItem = URLQueryItem.init(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                //urlComponents.queryItems?.append(queryItem)
                queryItems.append(queryItem)
            }
            
            urlComponents.queryItems = queryItems
            urlRequest.url = urlComponents.url
        }
    }
    
    /**
     加入額外的Header
     */
    func addAdditionalHeaders(_ additionalHeaders:HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    /**
    檢查回應代碼
    - Parameter response: 回傳的回應
    */
    func handleResponseCode(_ response: HTTPURLResponse) -> ResponseResult<String> {
        switch response.statusCode {
        case 200...299:
            return .success
            
        case 401...500:
            return .failure(NetworkResponse.authenticationError.rawValue)
            
        case 501...599:
            return .failure(NetworkResponse.badRequest.rawValue)
            
        case 600:
            return .failure(NetworkResponse.outdated.rawValue)
            
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
