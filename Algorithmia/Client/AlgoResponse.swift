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
    
    struct Metadata {
        let duration:Float
        let contentType:ContentType?
        let stdout:String?
        let alerts:[String]?
        
    }
    
    struct ErrorData {
        var message:String
        var stacktrace:String?
    }
    
    var rawData:Data?
    private var jsonData:[String: Any]?
    
    var error:ErrorData?
    
    init() {
        
    }
    
    func set(data:Data) throws {
        self.rawData = data
        do {
            try self.jsonData = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
        } catch {
            return;
        }
        
        if let errorInfo = self.jsonData?["error"] as? [String: Any] {
            var stacktrace:String?
            if let str = errorInfo["stacktrace"] as? String {
                stacktrace = str
            }
            
            if let message = errorInfo["message"] as? String {
                self.error = ErrorData(message: message, stacktrace: stacktrace)
                throw AlgoError.ProcessError(message)
            }
        }
        
    }
    
    func get()->Any {
        return jsonData?["result"]
    }
    
    func getText() -> String {
        return (jsonData?["result"] as? String)!
    }
    
    func getJson() -> Any {
        return jsonData?["result"]
    }
    
    func getData() -> Data {
        let result = jsonData?["result"] as! String
        return Data(base64Encoded: result)!
    }
    
    func getMetadata() -> Metadata {
        var metadata:Metadata
        let metadataInfo = self.jsonData?["metadata"] as! [String: Any]
        var type:ContentType = .UNKNOWN
        var stdout:String?
        var duration:Float = 0
        var alerts:[String]?
        
        if let typeStr = metadataInfo["content_type"] as? String {
            
            switch(typeStr) {
            case "json":
                type = .JSON
                break
            case "text":
                type = .TEXT
                break
            case "binary":
                type = .BINARY
                break
            default:
                type = .UNKNOWN
                break
            }
        }
        
        if let stdoutStr = metadataInfo["stdout"] as? String {
            stdout = stdoutStr
        }
        
        if let alertArray = metadataInfo["alerts"] as? [String] {
            alerts = alertArray
        }
        
        duration = metadataInfo["duration"] as! Float
        metadata = Metadata(duration: duration, contentType: type, stdout:stdout, alerts:alerts)
        return metadata
    }
    
}
