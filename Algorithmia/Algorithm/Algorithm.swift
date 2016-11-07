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
    
    func pipe(input:Any!, completion:@escaping AlgoCompletionHandler) -> AlgoRequest? {
        if let stringInput = input as? String {
            return pipe(text: stringInput, completion: completion)
        }
        else {
            return pipe(json: input, completion: completion)
        }
    }
    
    @discardableResult func pipe(text:String!, completion:@escaping AlgoCompletionHandler) -> AlgoRequest? {
        return client?.apiClient.post(path: algoRef.getPath(), data: AlgoStringEntity(entity: text), completion: completion)
        
    }
    
    @discardableResult func pipe(json:Any!, completion:@escaping AlgoCompletionHandler) -> AlgoRequest? {
        do {
            let entity = try AlgoJSONEntity(entity: json)
            return client?.apiClient.post(path: algoRef.getPath(), data: entity, completion: completion)
        } catch{
            completion(AlgoResponse(), AlgoError.DataError("Data can not be serialized"))
            return nil
        }

    }
    
    @discardableResult func pipe(rawJson:String!, completion:@escaping AlgoCompletionHandler) -> AlgoRequest? {
        do {
            let entity = try AlgoJSONEntity(plain: rawJson)
            return client?.apiClient.post(path: algoRef.getPath(), data: entity, completion: completion)
        } catch let error{
            completion(AlgoResponse(), AlgoError.DataError(error.localizedDescription))
            return nil
        }
    }
    
    @discardableResult func pipe(data:Data!, completion:@escaping AlgoCompletionHandler) -> AlgoRequest? {
        return client?.apiClient.post(path: algoRef.getPath(), data:  AlgoBinaryEntity(data: data), completion: completion)
    }
}
