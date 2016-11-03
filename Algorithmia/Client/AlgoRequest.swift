//
//  APIResponse.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgoRequest {
    
    public enum HTTPMethod: String {
        case GET    = "GET"
        case POST   = "POST"
        case PUT    = "PUT"
        case DELETE = "DELETE"
    }
    
    public enum MIMEType: String {
        case TEXT_PLAIN         = "text/plain"
        case APPLICATION_JSON   = "application/json"
        case APPLICATION_OCT    = "application/octet-stream"
    }
    
    public enum HTTPHeader {
        
        case ContentDisposition(String)
        case Accept([String])
        case ContentType(String)
        case Custom(String, String)
        
        var key: String {
            switch self {
            case .ContentDisposition:
                return "Content-Disposition"
            case .Accept:
                return "Accept"
            case .ContentType:
                return "Content-Type"
            case .Custom(let key, _):
                return key
            }
        }
        
        var requestHeaderValue: String {
            switch self {
            case .ContentDisposition(let disposition):
                return disposition
            case .Accept(let types):
                return types.joined(separator: ", ")
            case .ContentType(let type):
                return type
            case .Custom(_, let value):
                return value
            }
        }
        
    }
    
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
    
    func send(completion:@escaping AlgoCompletionHandler) {
        httpRequest.httpMethod = method.rawValue
        httpRequest.httpBody = data.body()
        for header in data.headers() {
            httpRequest.setValue(header.requestHeaderValue, forHTTPHeaderField: header.key)
        }
        let dataTask = session.dataTask(with: httpRequest) { (respData, resp, error) in
            if (respData == nil) {
                completion(AlgoResponse(),error)
            }
            else {
                completion(AlgoResponse(data: respData!), error)
            }
        }
        dataTask.resume()
    }
    
}
