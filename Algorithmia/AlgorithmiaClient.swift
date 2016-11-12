//
//  AlgorithmiaClient.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgorithmiaClient {
    var apiClient:AlgoAPIClient
    init() {
        self.apiClient = AlgoAPIClient(auth: nil)
    }
    init(auth:AlgorithmiaAuth) {
        self.apiClient = AlgoAPIClient(auth: auth)
    }
    
    
    /// Get algorithm object
    ///
    /// - parameter algoUri: algorithm uri, eg. 'algo://demo/Hello/0.1.1'
    ///
    /// - returns: Algorithm object
    func algo(algoUri:String) -> Algorithm {
        return Algorithm(client: self, algoRef: AlgorithmRef(algoUri: algoUri))
    }
    
}
