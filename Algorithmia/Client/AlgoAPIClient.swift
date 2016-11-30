//
//  APIClient.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation


public typealias AlgoCompletionHandler = (AlgoResponse,Error?)-> Void
public typealias AlgoDataCompletionHandler = (AlgoResponseData)-> Void
public typealias AlgoDownloadCompletionHandler = (URL?,Error?)-> Void
public typealias AlgoSimpleCompletionHandler = (Error?)-> Void
/**
 * A minimal API client
 */
class AlgoAPIClient {
    
    
    var auth:AlgorithmiaAuth? = nil
    let baseUrl:String
    var session:URLSession
    
    init(auth:AlgorithmiaAuth?, baseUrl:String) {
        self.auth = auth
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        self.baseUrl = baseUrl + "/"
        
    }
    
    func addQuery(path:String, parameters:[String:String]) -> String {
        var array=[String]()
        for (key,value) in parameters {
            array.append(key+"="+value)
        }
        return path.appending("?"+array.joined(separator: "&"))
    }
    
    func execute(path:String, data:AlgoEntity, options:[String:String], completion:@escaping AlgoCompletionHandler) -> AlgoRequest {
        var queryPath = path
        if options.count>0 {
            queryPath = addQuery(path: path, parameters: options)
        }
        let request = AlgoRequest(path: baseUrl+queryPath, session: session, method: .POST, data: data)
        self.auth?.authenticate(request: request)
        
        request.execute(completion: completion)
        return request;
        
    }
    
    func send(method:AlgoRequest.HTTPMethod, path:String, data:AlgoEntity?, completion:@escaping AlgoDataCompletionHandler) -> AlgoRequest {

        let request = AlgoRequest(path: baseUrl+path, session: session, method: method, data: data)
        self.auth?.authenticate(request: request)
        
        request.send(completion: completion)
        return request;
        
    }
    
    func send(method:AlgoRequest.HTTPMethod, path:String, data:AlgoEntity?, options:[String:String], completion:@escaping AlgoDataCompletionHandler) -> AlgoRequest {
        
        var queryPath = path
        if options.count>0 {
            queryPath = addQuery(path: path, parameters: options)
        }
        let request = AlgoRequest(path: baseUrl+queryPath, session: session, method: method, data: data)
        self.auth?.authenticate(request: request)
        
        request.send(completion: completion)
        return request;
        
    }
    
    func put(path:String, file:URL, completion:@escaping AlgoDataCompletionHandler) {
        let request = AlgoRequest(path: baseUrl+path, session: session, method: .PUT, data:nil)
        self.auth?.authenticate(request: request)
        request.send(file:file, completion: completion)
    }
    
    func download(path:String, completion:@escaping AlgoDownloadCompletionHandler) {
        let request = AlgoRequest(path: baseUrl+path, session: session, method: .GET, data:nil)
        self.auth?.authenticate(request: request)
        request.download(completion: completion)
    }
    
}
