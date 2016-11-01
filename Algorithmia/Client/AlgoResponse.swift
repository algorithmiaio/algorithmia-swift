//
//  AlgoResponse.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgoResponse {
    let rawData:Data
    var jsonData:[String: Any]?
    var error:String?
    init(data:Data) {
        self.rawData = data
        do {
            try self.jsonData = JSONSerialization.jsonObject(with: rawData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
        }catch _ {
           self.jsonData = nil
        }
    }
    
    func get()->[String: Any]? {
        return jsonData
    }
    
    func getText() -> String? {
        return jsonData?["result"] as? String
    }
}
