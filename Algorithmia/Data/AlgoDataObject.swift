//
//  DataObject.swift
//  Algorithmia
//
//  Created by Erik Ilyin on 11/10/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgoDataObject {
    enum DataObjectType {
        case File
        case Directory
    }
    
    
    let path:String
    
    let client:AlgoAPIClient
    let dataType:DataObjectType
    
    init(client:AlgoAPIClient, dataUrl:String, type:DataObjectType) {
        self.client = client
        self.path = dataUrl.replacingOccurrences(of: "^data://|^/", with: "", options: .regularExpression)
        self.dataType = type
    }
    
    func exists(completion:@escaping (Bool,Error?)-> Void) {
        _ = client.send(method:.HEAD, path: getUrl(), data:nil) { (resp, error) in
            if resp.statusCode == 200 {
                completion(true, nil)
            }
            else if resp.statusCode == 404 {
                completion(false, nil)
            }
            else {
                completion(false, error)
            }
        }
    }
    
    func getUrl() -> String {
        
        return "v1/data/" + self.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func parent() -> AlgoDataDirectory? {
        if let range = self.path.range(of: "/", options: .backwards) {
            return AlgoDataDirectory(client:client, dataUrl:self.path.substring(to: range.upperBound))
        }
        else {
            return nil
        }
    }
    
    func basename() -> String {
        let range = self.path.range(of: "/", options: .backwards)!
        return self.path.substring(from: range.upperBound)
    }
    
    class DeletedResult {
        var isSuccess:Bool
        var deletedCount:Int
        init(_ json:[String:Any]) {
            isSuccess = false
            deletedCount = 0
            if let result = json["result"] as? [String:Int] {
                isSuccess = true
                if let deleted = result["deleted"] {
                    deletedCount = deleted
                }
            }
            if let result = json["error"] as? [String:Any] {
                isSuccess = false
                if let deleted = result["deleted"] as? Int {
                    deletedCount = deleted
                }
            }
        }
    }
}

