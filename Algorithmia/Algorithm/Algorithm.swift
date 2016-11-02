//
//  Algorithm.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class Algorithm {
    weak var client:AlgorithmiaClient?
    let algoRef:AlgorithmRef
    init(client:AlgorithmiaClient, algoRef:AlgorithmRef) {
        self.client = client
        self.algoRef = algoRef
    }
    
    func pipe(input:AnyObject!, completion:@escaping AlgoCompletionHandler) -> AlgoRequest? {
        if let stringInput = input as? String {
            return client?.apiClient.post(path: algoRef.getPath(), data: AlgoStringEntity(entity: stringInput), completion: completion )
        }
        return nil
    }
    func pipe(input:String!, completion:@escaping AlgoCompletionHandler) -> AlgoRequest? {
        return client?.apiClient.post(path: algoRef.getPath(), data: AlgoStringEntity(entity: input), completion: completion)
        
    }
}
