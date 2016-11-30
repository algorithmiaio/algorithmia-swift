//
//  DataObject.swift
//  Algorithmia
//
//  Created by Erik Ilyin on 11/10/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

/// Base object to file and directory
public class AlgoDataObject {
    public enum DataObjectType {
        case File
        case Directory
    }
    
    public enum DataACL {
        case PUBLIC
        case MY_ALGORITHMS
        case PRIVATE
        var value:[String] {
            switch self {
            case .PUBLIC:
                return ["user://*"]
            case .MY_ALGORITHMS:
                return ["algo://.my/*"]
            default:
                return []
            }
        }
    }
    
    open let path:String
    
    let client:AlgoAPIClient
    let dataType:DataObjectType
    
    init(client:AlgoAPIClient, dataUrl:String, type:DataObjectType) {
        self.client = client
        self.path = dataUrl
        self.dataType = type
    }
    
    
    /// Check if file exists
    ///
    /// - parameter completion: completion handler
    public func exists(completion:@escaping (Bool,Error?)-> Void) {
        _ = client.send(method:.HEAD, path: getUrl(), data:nil) { resp in
            if resp.statusCode == 200 {
                completion(true, nil)
            }
            else if resp.statusCode == 404 {
                completion(false, nil)
            }
            else {
                completion(false, resp.error)
            }
        }
    }
    
    func getUrl() -> String {
        var connector = "data"
        var subPath = self.path
        if let range = self.path.range(of: "://") {
            connector = self.path.substring(to: range.lowerBound)
            subPath = self.path.substring(from: range.upperBound)
        }
        return Algo.DATA_BASE_PATH + "/" + connector + "/" + subPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    
    /// Return parent directory object. It return nil if this is root directory
    ///
    /// - returns: Directory object
    public func parent() -> AlgoDataDirectory? {
        if let range = self.path.range(of: "/", options: .backwards) {
            return AlgoDataDirectory(client:client, dataUrl:self.path.substring(to: range.upperBound))
        }
        else {
            return nil
        }
    }
    
    
    /// Return name of File/Directory object
    ///
    /// - returns: name of file/directory
    public func basename() -> String {
        let range = self.path.range(of: "/", options: .backwards)!
        return self.path.substring(from: range.upperBound)
    }
    
    
    /// Return full path of File/Directory. e.g., data://.my/foo/bar.txt
    ///
    /// - returns: full path of File/Directory
    public func toDataURI() -> String {
        return self.path
    }
    
    public class DeletedResult {
        public var isSuccess:Bool
        public var deletedCount:Int
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

