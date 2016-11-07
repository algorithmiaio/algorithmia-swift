//
//  AlgoResponse.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgoResponse {
    
    enum ContentType {
        case UNKNOWN
        case TEXT
        case JSON
        case BINARY
    }
    
    private let rawData:Data
    var jsonData:[String: Any]?
    var contentType:ContentType = .UNKNOWN
    var error:String?
    init() {
        rawData = Data()
    }
    init(data:Data) {
        self.rawData = data
        do {
            try self.jsonData = JSONSerialization.jsonObject(with: rawData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
            
            self.contentType = .BINARY
        }catch _ {
            self.jsonData = nil
            
        }
        
    }
    
    func get()->Any? {
        return jsonData?["result"]
    }
    
    func getText() -> String? {
        return jsonData?["result"] as? String
    }
    
    func getJSON() -> Any {
        return jsonData?["result"]
    }
    
    func getData() -> Data? {
        let result = jsonData?["result"] as? String
        if result != nil {
            return Data(base64Encoded: result!)
        }
        else {
            return nil
        }
        
    }
}
