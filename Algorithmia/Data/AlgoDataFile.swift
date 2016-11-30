//
//  DataFile.swift
//  Algorithmia
//
//  Created by Erik Ilyin on 11/10/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

/// Object to file in the data API
public class AlgoDataFile:AlgoDataObject {
    
    init(client: AlgoAPIClient, dataUrl: String) {
        super.init(client: client, dataUrl: dataUrl, type: .File)
    }
    

    /// Get data from this file as string using UTF-8 charset, @warning It return error in handler if data is not UTF-8 charset.
    ///
    /// - parameter completion: completion handler. It takes two parameter
    /// * string: string that is decoded as utf-8 charset
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func getString(completion:@escaping (String?, Error?) -> Void) {
        _ = client.send(method:.GET, path: getUrl(), data:nil) { resp  in
            if resp.statusCode == 200 {
                if let data = resp.rawData {
                    if let str = String(data: data, encoding: .utf8) {
                        completion(str, resp.error)
                    }
                    else {
                        completion(nil, AlgoError.DataError("Data is not valid UTF-8"))
                    }
                    return;
                }
            }
            completion(nil, resp.error)
        }
    }
    
    /// Get data from this file as binary
    ///
    /// - parameter completion: completion handler. It takes two parameter
    /// * data: data object
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func getData(completion:@escaping (Data?, Error?) -> Void) {
        _ = client.send( method:.GET, path: getUrl(), data:nil) { resp in
            completion(resp.rawData, resp.error)
        }
    }
    
    /// Download file into local storage
    ///
    /// - parameter completion: completion handler. It takes two parameter
    /// * url: url of local file
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func getFile(completion:@escaping AlgoDownloadCompletionHandler) {
        client.download(path: getUrl(), completion: completion)
    }
    
    
    /// Upload binary data into file on server
    ///
    /// - parameter data:       data object
    /// - parameter completion: completion handler. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func put(data:Data, completion:@escaping (Error?) -> Void) {
        _ = client.send(method:.PUT, path: getUrl(), data: AlgoBinaryEntity(data:data)) { resp in
            completion(resp.error)
        }
    }
    
    /// Upload string(UTF-8) to file on server
    ///
    /// - parameter string:       string object
    /// - parameter completion: completion handler. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func put(string:String, completion:@escaping (Error?) -> Void) {
        _ = client.send(method:.PUT, path: getUrl(), data: AlgoStringEntity(entity:string)) { resp in
            completion(resp.error)
        }
    }
    
    /// Upload local file to server
    ///
    /// - parameter file:       url of local file
    /// - parameter completion: completion handler. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func put(file:URL, completion:@escaping (Error?) -> Void) {
        client.put(path: getUrl(), file: file) { resp in
            completion(resp.error)
        }
    }
    
    /// Delete file on server
    ///
    /// - parameter completion: completion handler. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func delete(completion:@escaping (Error?) -> Void) {
        _ = client.send(method: .DELETE, path: getUrl(), data: nil) { resp in
            completion(resp.error)
        }
    }
    
}
