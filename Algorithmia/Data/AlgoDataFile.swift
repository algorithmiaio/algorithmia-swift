//
//  DataFile.swift
//  Algorithmia
//
//  Created by Erik Ilyin on 11/10/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgoDataFile:AlgoDataObject {
    init(client: AlgoAPIClient, dataUrl: String) {
        super.init(client: client, dataUrl: dataUrl, type: .File)
    }
    
    func getString(completion:@escaping (String?, Error?) -> Void) {
        _ = client.send(method:.GET, path: getUrl()) { (resp, error) in
            if let data = resp.rawData {
                completion(String(data: data, encoding: .utf8), error)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    func getData(completion:@escaping (Data?, Error?) -> Void) {
        _ = client.send( method:.GET, path: getUrl(), data:nil) { (resp, error) in
            completion(resp.rawData, error)
        }
    }
    
    func getFile(completion:@escaping AlgoDownloadCompletionHandler) {
        client.download(path: getUrl(), completion: completion)
    }
    
    func put(data:Data, completion:@escaping (Error?) -> Void) {
        _ = client.send(method:.PUT, path: getUrl(), data: AlgoBinaryEntity(data:data)) { (resp, error) in
            completion(error)
        }
    }
    
    func put(string:String, completion:@escaping (Error?) -> Void) {
        _ = client.send(method:.PUT, path: getUrl(), data: AlgoStringEntity(entity:string)) { (resp, error) in
            completion(error)
        }
    }
    
    func put(file:URL, completion:@escaping (Error?) -> Void) {
        client.put(path: getUrl(), file: file, completion: completion)
    }
    
    func delete(completion:@escaping (Error?) -> Void) {
        _ = client.send(method: .DELETE, path: getUrl(), data: nil) { (resp, error) in
            completion(error)
        }
    }
    
}
