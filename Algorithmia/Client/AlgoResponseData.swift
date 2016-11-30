//
//  AlgoResponseData.swift
//  Algorithmia
//
//  Created by Erik Ilyin on 11/14/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

public class AlgoResponseData {
    var statusCode:Int=0
    var rawData:Data?
    var error:Error?
    init() {
        
    }
    
    init(response:URLResponse?, data:Data?, error:Error?) {
        if let response = response as? HTTPURLResponse {
            statusCode = response.statusCode
        }
        rawData = data
        self.error = error
        if let json = try? getJSON() {
            if let error = json?["error"] as? [String:Any] {
                if let message = error["message"] as? String {
                    self.error = AlgoError.ProcessError(statusCode, message)
                }
            }
        }
    }
    
    func getJSON() throws -> [String: Any]? {
        let jsonData = try JSONSerialization.jsonObject(with: rawData!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
        return jsonData
    }
    
    func errorMessage() -> String? {
        if let json = try? getJSON() {
            if let error = json?["error"] as? [String:Any] {
                if let message = error["message"] as? String {
                    return message
                }
            }
        }
        return nil
    }
}
