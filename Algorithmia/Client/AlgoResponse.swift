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
    var statusCode:Int=0
    var rawData:Data?
    private var jsonData:[String: Any]?
    
    /// Error
    /// * message
    /// * stacktrace
    var error:ErrorData?
    
    init() {
        
    }
    
    init(code:Int) {
        self.statusCode = code
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
    
    
    /// Get text output
    /// @warning Please make sure it return text content, otherwise it can cause error. You can check content type from getMetadata() function
    /// - returns: return text output.
    func getText() -> String {
        return jsonData?["result"] as! String
    }
    
    /// Get json output
    /// @warning Please make sure it return json content, otherwise it can cause error. You can check content type from getMetadata() function
    /// - returns: return json output. It can be Dictionary or Array
    func getJson() -> Any {
        return jsonData?["result"]
    }
    
    
    /// Get binary output
    /// @warning Please make sure it return binary content, otherwise it can cause error. You can check content type from getMetadata() function
    /// - returns: return binary output.
    func getData() -> Data {
        let result = jsonData?["result"] as! String
        return Data(base64Encoded: result)!
    }
    
    
    /// Get metadata
    ///
    /// - returns: Metadata object 
    /// * contentType: content type of metadata
    /// * duration: duration time taken by algorithm
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
