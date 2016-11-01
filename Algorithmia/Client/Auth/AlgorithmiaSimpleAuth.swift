//
//  AlgorithmiaSimpleAuth.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

/**
 * An Auth implementation for the Algorithmia Simple Auth API key
 */
class AlgorithmiaSimpleAuth:AlgorithmiaAuth {
    var apiKey:String?
    override init() {
        self.apiKey = nil
    }
    init(apiKey:String) {
        self.apiKey = apiKey
    }
    
    override func authenticate(request: AlgoRequest) {
        
        request.setHeader(value: "Simple " + self.apiKey!, key: "Authorization")
    }
}
