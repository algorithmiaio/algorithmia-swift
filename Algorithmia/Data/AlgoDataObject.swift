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
    
    struct DeletedResult {
        let isSuccess:Bool
        let count:Int
    }
}

