//
//  APIClient.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

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
    
    
    
    func post(path:String, data:AlgoEntity) -> AlgoRequest {
        let request = AlgoRequest(path: path, session: session, method: HTTPMethod.POST, data: data)
        self.auth?.authenticate(request: request)
        
        return request
        
    }
    
}
