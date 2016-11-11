//
//  APIClient.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation



typealias AlgoCompletionHandler = (AlgoResponse,Error?)-> Void
typealias AlgoDownloadCompletionHandler = (URL?,Error?)-> Void
/**
 * A minimal API client
 */
class AlgoAPIClient {
    
    
    var auth:AlgorithmiaAuth? = nil
    static let apiBaseURL=URL(string: "https://api.algorithmia.com/")!
    
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
        return apiBaseURL
    }
    
    func send(method:AlgoRequest.HTTPMethod, path:String, completion:@escaping AlgoCompletionHandler) {
        let request = AlgoRequest(path: path, session: session, method: method)
        self.auth?.authenticate(request: request)
        request.send(completion: completion)
    }
    
    func put(path:String, data:AlgoEntity, completion:@escaping (Error?) -> Void) {
        let request = AlgoRequest(path: path, session: session, method: .PUT, data: data)
        self.auth?.authenticate(request: request)
        request.sendData(completion: completion)
    }
    
    func put(path:String, file:URL, completion:@escaping (Error?) -> Void) {
        let request = AlgoRequest(path: path, session: session, method: .PUT)
        self.auth?.authenticate(request: request)
        request.send(file:file, completion: completion)
    }
    
    func download(path:String, completion:@escaping AlgoDownloadCompletionHandler) {
        let request = AlgoRequest(path: path, session: session, method: .GET)
        self.auth?.authenticate(request: request)
        request.download(completion: completion)
    }
    
    func post(path:String, data:AlgoEntity, options:[String:String], completion:@escaping AlgoCompletionHandler) -> AlgoRequest {
        var queryPath = path
        if options.count>0 {
            queryPath = addQuery(path: path, parameters: options)
        }
        let request = AlgoRequest(path: queryPath, session: session, method: .POST, data: data)
        self.auth?.authenticate(request: request)
        
        request.send(completion: completion)
        return request;
        
    }
    
    func delete(path:String, completion:@escaping (Error?) -> Void) {
        let request = AlgoRequest(path: path, session: session, method: .DELETE)
        self.auth?.authenticate(request: request)
        request.send { (resp, error) in
            
        }
    }
    
}
