//
//  Algorithm.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

/**
 * Represents an Algorithmia algorithm that can be called
 */
public class Algorithm {
    weak var client:AlgorithmiaClient?
    let algoRef:AlgorithmRef
    var options:[String: String] = [String: String]()
    init(client:AlgorithmiaClient, algoRef:AlgorithmRef) {
        self.client = client
        self.algoRef = algoRef
    }
    
    /// Set option
    ///
    /// - parameter option: option to set, eg. timeout, stdout, output
    ///
    /// - returns: Algorithm object
    public func setOption(_ option:AlgoOption) -> Self {
        options[option.key] = option.value
        return self
    }
    
    
    /// Set timeout option for algorithm
    ///
    /// - parameter timeout: timeout for algorithm
    ///
    /// - returns: Algorithm object
    public func set(timeout:Int) -> Self {
        return setOption(.Timeout(timeout))
    }
    
    public func set(stdout:Bool) -> Self {
        return setOption(.Stdout(stdout))
    }
    
    /// Calls the Alogirhtmia API for given input
    ///
    /// - parameter text:       algorithm text input
    /// - parameter completion: completion handler, return response and error. For output, check getText(), getJson(), getData() in AlgoResponse object.
    ///
    /// - returns: Request object
    @discardableResult public func pipe(text:String!, completion:@escaping AlgoCompletionHandler) -> AlgoRequest? {
        return client?.apiClient.execute(path: algoRef.getPath(), data: AlgoStringEntity(entity: text), options: options, completion: completion)
    }
    
    /// Calls the Alogirhtmia API for given input
    ///
    /// - parameter text:       algorithm json input, can be Any which is serializable in Json - eg. Array, Dictionary
    /// - parameter completion: completion handler, return response and error. For output, check getText(), getJson(), getData() in AlgoResponse object.
    ///
    /// - returns: Request object
    @discardableResult public func pipe(json:Any!, completion:@escaping AlgoCompletionHandler) -> AlgoRequest? {
        do {
            let entity = try AlgoJSONEntity(entity: json)
            return client?.apiClient.execute(path: algoRef.getPath(), data: entity, options: options, completion: completion)
        } catch{
            completion(AlgoResponse(), AlgoError.DataError("Data can not be serialized"))
            return nil
        }

    }
    
    /// Calls the Alogirhtmia API for given input
    ///
    /// - parameter rawJson:       algorithm raw json input, eg. [\"alice\",\"json\"]
    /// - parameter completion: completion handler, return response and error. For output, check getText(), getJson(), getData() in AlgoResponse object.
    ///
    /// - returns: Request object
    @discardableResult public func pipe(rawJson:String!, completion:@escaping AlgoCompletionHandler) -> AlgoRequest? {
        do {
            let entity = try AlgoJSONEntity(plain: rawJson)
            return client?.apiClient.execute(path: algoRef.getPath(), data: entity, options: options, completion: completion)
        } catch let error{
            completion(AlgoResponse(), AlgoError.DataError(error.localizedDescription))
            return nil
        }
    }
    
    /// Calls the Alogirhtmia API for given input
    ///
    /// - parameter data:       algorithm binary input, Data
    /// - parameter completion: completion handler, return response and error. For output, check getText(), getJson(), getData() in AlgoResponse object.
    ///
    /// - returns: Request object
    @discardableResult public func pipe(data:Data!, completion:@escaping AlgoCompletionHandler) -> AlgoRequest? {
        return client?.apiClient.execute(path: algoRef.getPath(), data:  AlgoBinaryEntity(data: data), options:options, completion: completion)
    }
}
