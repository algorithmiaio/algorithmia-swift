//
//  AlgorithmiaClient.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

public class AlgorithmiaClient {
    var apiClient:AlgoAPIClient
    init() {
        var auth:AlgorithmiaAuth?
        if let apiKey = ProcessInfo.processInfo.environment["ALGORITHMIA_API_KEY"] {
            auth = AlgorithmiaSimpleAuth(apiKey:apiKey)
        }
        self.apiClient = AlgoAPIClient(auth: auth, baseUrl:Algo.apiBaseUrl)
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
    public func algo(algoUri:String) -> Algorithm {
        return Algorithm(client: self, algoRef: AlgorithmRef(algoUri: algoUri))
    }
    
    /// Get file object
    ///
    /// - parameter path: path to a data file, e.g., data://.my/foo/bar.txt
    ///
    /// - returns: a DataFile client for the specified file
    public func file(_ path:String) -> AlgoDataFile {
        return AlgoDataFile(client: apiClient, dataUrl: path)
    }
    
    /// Get file object
    ///
    /// - parameter path: path to a data directory, e.g., data://.my/foo
    ///
    /// - returns: a DataDirectory client for the specified directory
    public func dir(_ path:String) -> AlgoDataDirectory {
        return AlgoDataDirectory(client: apiClient, dataUrl: path)
    }
}
