//
//  APIClient.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation



typealias AlgoCompletionHandler = (AlgoResponse,Error?)-> Void
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
    
    
    func post(path:String, data:AlgoEntity, options:[String:String], completion:@escaping AlgoCompletionHandler) -> AlgoRequest {
        var queryPath = path
        if options.count>0 {
            queryPath = addQuery(path: path, parameters: options)
        }
        let request = AlgoRequest(path: queryPath, session: session, method: AlgoRequest.HTTPMethod.POST, data: data)
        self.auth?.authenticate(request: request)
        
        request.send(completion: completion)
        return request;
        
    }
    
}
