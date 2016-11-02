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
 * A minimal HTTP client
 */
class AlgoAPIClient {
    
    
    var auth:AlgorithmiaAuth? = nil
    static let apiBaseURL=URL(string: "https://api.algorithmia.com/v1/algo/")!
    
    var session:URLSession
    
    init(auth:AlgorithmiaAuth?) {
        self.auth = auth
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public static func baseURL() -> URL {
        return apiBaseURL
    }
    
    
    
    func post(path:String, data:AlgoEntity, completion:@escaping AlgoCompletionHandler) -> AlgoRequest {
        let request = AlgoRequest(path: path, session: session, method: AlgoRequest.HTTPMethod.POST, data: data)
        self.auth?.authenticate(request: request)
        
        request.send(completion: completion)
        return request;
        
    }
    
}
