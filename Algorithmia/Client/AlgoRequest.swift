//
//  APIResponse.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgoRequest {
    
    let path:String
    let method:HTTPMethod
    var contentType:MIMEType?
    let data:AlgoEntity
    var httpRequest:URLRequest
    var session:URLSession
    
    init(path:String, session:URLSession, method:HTTPMethod, data:AlgoEntity) {
        self.path = path
        self.method = method
        self.data = data
        self.session = session
        
        let url = URL(string: path, relativeTo: AlgoAPIClient.baseURL())
        self.httpRequest = URLRequest(url: url!)
    }
    
    func setHeader(value:String?, key:String) {
        httpRequest.setValue(value, forHTTPHeaderField: key)
    }
    
    func sendRequest(headers: [HTTPHeader], completion:@escaping AlgoCompletionHandler) {
        httpRequest.httpMethod = method.rawValue
        httpRequest.httpBody = data.body()
        for header in headers {
            httpRequest.setValue(header.requestHeaderValue, forHTTPHeaderField: header.key)
        }
        let dataTask = session.dataTask(with: httpRequest) { (respData, resp, error) in
            if (respData == nil) {
                completion(AlgoResponse(),error)
            }
            else {
                completion(AlgoResponse(data: respData!), nil)
            }
        }
        dataTask.resume()
    }
    
    func asText(completion: @escaping AlgoCompletionHandler) -> Self {
        sendRequest(
            headers     : [HTTPHeader.ContentType(MIMEType.TEXT_PLAIN.rawValue)],
            completion  : completion
        )
        return self
    }
    
    
}
