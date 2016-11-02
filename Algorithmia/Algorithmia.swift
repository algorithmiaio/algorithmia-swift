//
//  Algorithmia.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation
/**
 * Instantiate Algorithmia clients for calling algorithms and accessing data
 */
class Algorithmia {
    static let defaultClient=AlgorithmiaClient()
    public static func client() -> AlgorithmiaClient {
        return getDefaultClient();
    }
    
    
    public static func client(simpleKey:String) -> AlgorithmiaClient {
        return AlgorithmiaClient(auth: AlgorithmiaSimpleAuth(apiKey: simpleKey))
    }
    
    static func getDefaultClient() -> AlgorithmiaClient {
        return defaultClient;
    }
    
}
