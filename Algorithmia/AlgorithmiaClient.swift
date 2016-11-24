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
        self.apiClient = AlgoAPIClient(auth: nil, baseUrl:Algo.apiBaseUrl)
    }
    init(auth:AlgorithmiaAuth) {
        self.apiClient = AlgoAPIClient(auth: auth, baseUrl:Algo.apiBaseUrl)
    }
    
    init(auth:AlgorithmiaAuth, baseUrl:String) {
        self.apiClient = AlgoAPIClient(auth: auth, baseUrl:baseUrl)
    }
    /// Get algorithm object
    ///
    /// - parameter algoUri: algorithm uri, eg. 'algo://demo/Hello/0.1.1'
    ///
    /// - returns: Algorithm object
    func algo(algoUri:String) -> Algorithm {
        return Algorithm(client: self, algoRef: AlgorithmRef(algoUri: algoUri))
    }
    
    /// Get file object
    ///
    /// - parameter path: path to a data file, e.g., data://.my/foo/bar.txt
    ///
    /// - returns: a DataFile client for the specified file
    func file(_ path:String) -> AlgoDataFile {
        return AlgoDataFile(client: apiClient, dataUrl: path)
    }
    
    /// Get file object
    ///
    /// - parameter path: path to a data directory, e.g., data://.my/foo
    ///
    /// - returns: a DataDirectory client for the specified directory
    func dir(_ path:String) -> AlgoDataDirectory {
        return AlgoDataDirectory(client: apiClient, dataUrl: path)
    }
}
