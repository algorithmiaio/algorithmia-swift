//
//  AlgoResponseData.swift
//  Algorithmia
//
//  Created by Erik Ilyin on 11/14/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgoResponseData {
    var statusCode:Int=0
    var rawData:Data?
    
    init() {
        
    }
    
    init(response:URLResponse?, data:Data?) {
        if let response = response as? HTTPURLResponse {
            statusCode = response.statusCode
        }
        rawData = data
    }
    
    func getJSON() throws -> [String: Any]? {
        let jsonData = try JSONSerialization.jsonObject(with: rawData!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
        return jsonData
    }
}
