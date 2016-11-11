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
        case HEAD   = "HEAD"
    }
    
    public enum MIMEType: String {
        case TEXT_PLAIN         = "text/plain"
        case APPLICATION_JSON   = "application/json"
        case APPLICATION_OCT    = "application/octet-stream"
    }
    
    public enum HTTPHeader {
        
        case UserAgent(String)
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
            case .UserAgent:
                return "User-Agent"
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
            case .UserAgent(let agent):
                return agent
            }
        }
        
    }
    
    let path:String
    let method:HTTPMethod
    var contentType:MIMEType?
    let data:AlgoEntity?
    var httpRequest:URLRequest?
    var session:URLSession
    var dataTask:URLSessionDataTask?
    var headers:[HTTPHeader]
    
    init(path:String, session:URLSession, method:HTTPMethod) {
        self.path = path
        self.method = method
        self.session = session
        let agentHeader = HTTPHeader.UserAgent(String(format:"algorithmia-swift/%@ (Swift %@)",Algo.CLIENT_VERSION,Algo.SWIFT_VERSION))
        self.headers = [agentHeader]
        self.data = nil
    }
    
    init(path:String, session:URLSession, method:HTTPMethod, data:AlgoEntity) {
        self.path = path
        self.method = method
        self.data = data
        self.session = session
        let agentHeader = HTTPHeader.UserAgent(String(format:"algorithmia-swift/%@ (Swift %@)",Algo.CLIENT_VERSION,Algo.SWIFT_VERSION))
        self.headers = [agentHeader]
    }
    
    func setHeader(value:String, key:String) {
        headers.append(HTTPHeader.Custom(key, value))
    }
    
    func send(completion:@escaping AlgoCompletionHandler) {
        let url = URL(string: path, relativeTo: AlgoAPIClient.baseURL())
        var httpRequest = URLRequest(url: url!)
        httpRequest.httpMethod = method.rawValue
        
        // HTTP headers
        if let dataHeaders = data?.headers() {
            headers.append(contentsOf: dataHeaders)
        }
        
        for header in headers {
            httpRequest.addValue(header.requestHeaderValue, forHTTPHeaderField: header.key)
        }
        
        // HTTP Body
        httpRequest.httpBody = data?.body()
        session.uploadTask(withStreamedRequest: httpRequest)
        // Send HTTP Request
        dataTask = session.dataTask(with: httpRequest) { (respData, response, error) in
            var code = 0
            if let httpResponse = response as? HTTPURLResponse {
                code = httpResponse.statusCode
            }
            if (respData == nil) {
                completion(AlgoResponse(code: code),error)
            }
            else {
                let response = AlgoResponse(code: code)
                if (error != nil) {
                    completion(response, error)
                }
                else {
                    do {
                        try response.set(data: respData!)
                        completion(response, error)
                    } catch let e {
                        completion(response, e)
                    }
                }
                
            }
        }
        dataTask?.resume()
    }
    
}
