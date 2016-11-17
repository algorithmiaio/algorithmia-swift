//
//  APIClient.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation


typealias AlgoCompletionHandler = (AlgoResponse,Error?)-> Void
typealias AlgoDataCompletionHandler = (AlgoResponseData)-> Void
typealias AlgoDownloadCompletionHandler = (URL?,Error?)-> Void
typealias AlgoSimpleCompletionHandler = (Error?)-> Void
/**
 * A minimal API client
 */
class AlgoAPIClient {
    
    
    var auth:AlgorithmiaAuth? = nil
    
    var session:URLSession
    
    init(auth:AlgorithmiaAuth?) {
        self.auth = auth
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func addQuery(path:String, parameters:[String:String]) -> String {
        var array=[String]()
        for (key,value) in parameters {
            array.append(key+"="+value)
        }
        return path.appending("?"+array.joined(separator: "&"))
    }
    
    public static func baseURL() -> URL {
        return Algo.apiBaseURL
    }
    
    func execute(path:String, data:AlgoEntity, options:[String:String], completion:@escaping AlgoCompletionHandler) -> AlgoRequest {
        var queryPath = path
        if options.count>0 {
            queryPath = addQuery(path: path, parameters: options)
        }
        let request = AlgoRequest(path: queryPath, session: session, method: .POST, data: data)
        self.auth?.authenticate(request: request)
        
        request.execute(completion: completion)
        return request;
        
    }
    
    func send(method:AlgoRequest.HTTPMethod, path:String, data:AlgoEntity?, completion:@escaping AlgoDataCompletionHandler) -> AlgoRequest {

        let request = AlgoRequest(path: path, session: session, method: method, data: data)
        self.auth?.authenticate(request: request)
        
        request.send(completion: completion)
        return request;
        
    }
    
    func send(method:AlgoRequest.HTTPMethod, path:String, data:AlgoEntity?, options:[String:String], completion:@escaping AlgoDataCompletionHandler) -> AlgoRequest {
        
        var queryPath = path
        if options.count>0 {
            queryPath = addQuery(path: path, parameters: options)
        }
        let request = AlgoRequest(path: queryPath, session: session, method: method, data: data)
        self.auth?.authenticate(request: request)
        
        request.send(completion: completion)
        return request;
        
    }
    
    func put(path:String, file:URL, completion:@escaping AlgoDataCompletionHandler) {
        let request = AlgoRequest(path: path, session: session, method: .PUT, data:nil)
        self.auth?.authenticate(request: request)
        request.send(file:file, completion: completion)
    }
    
    func download(path:String, completion:@escaping AlgoDownloadCompletionHandler) {
        let request = AlgoRequest(path: path, session: session, method: .GET, data:nil)
        self.auth?.authenticate(request: request)
        request.download(completion: completion)
    }
    
}
