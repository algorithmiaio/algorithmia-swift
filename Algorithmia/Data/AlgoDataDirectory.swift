//
//  AlgoDataDirectory.swift
//  Algorithmia
//
//  Created by Erik Ilyin on 11/11/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

public typealias AlgoDataListingHandler = ( AlgoDataObject?) -> Void

public class AlgoDataDirectory:AlgoDataObject {
    
    init(client: AlgoAPIClient, dataUrl: String) {
        var dirUrl = dataUrl
        if dataUrl.hasSuffix("/") {
            dirUrl = dataUrl.substring(to: dataUrl.index(before: dataUrl.endIndex))
        }
        super.init(client: client, dataUrl: dirUrl, type: .Directory)
    }
    
    
    /// Create directory on server
    ///
    /// - parameter completion: completion handler. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func create(_ completion:@escaping AlgoSimpleCompletionHandler) {
        self.create(readACL: nil, completion: completion)
    }
    
    /// Create directory on server with read access control list
    ///
    /// - parameter readACL: read access control list for new directory.
    /// - parameter completion: completion handler. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func create(readACL:DataACL? , completion:@escaping AlgoSimpleCompletionHandler) {
        
        var param:[String:Any] = ["name":self.basename()]
        if let readACL = readACL {
            param["acl"] = ["read":readACL.value]
        }
        
        let entity = try! AlgoJSONEntity(entity: param)
        _ = client.send(method: .POST, path: self.parent()!.getUrl(), data: entity) { respData in
            completion(respData.error)
        }
    }
    
    /// Update directory access control list
    ///
    /// - parameter readACL: read access control list for current directory.
    /// - parameter completion: completion handler. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func update(readACL:DataACL , completion:@escaping AlgoSimpleCompletionHandler) {
        let entity = try! AlgoJSONEntity(entity: ["acl":["read":readACL.value]])
        _ = client.send(method: .PATCH, path: self.getUrl(), data: entity) { respData in
            completion(respData.error)
        }
    }
    
    /// Delete directory on server
    ///
    /// - parameter force: boolean that indicates force deletion of directory even if it still has other files in it
    /// - parameter completion: completion handler. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func delete(force:Bool, completion:@escaping (DeletedResult?, Error?) -> Void ) {
        _ = client.send(method: .DELETE, path: self.getUrl(), data: nil, options:["force":String(force)]) { respData in
            var jsonData:[String:Any]?
            var aError:Error?
            do {
                try jsonData = respData.getJSON()
                if let json = jsonData {
                    completion(DeletedResult(json), respData.error)
                    return;
                }
            } catch {
                aError = AlgoError.UnknownError
            }
            completion(nil,aError ?? respData.error)
            
        }
    }
    
    
    /// Return file in directory
    ///
    /// - parameter name: filename
    ///
    /// - returns: File object in directory
    public func file(name:String) -> AlgoDataFile {
        return AlgoDataFile(client: self.client, dataUrl: self.path + "/" + name)
    }
    
    
    /// return sub directory
    ///
    /// - parameter name: name of directory
    ///
    /// - returns: Directory object
    public func dir(name:String) -> AlgoDataDirectory {
        return AlgoDataDirectory(client: self.client, dataUrl: self.path + "/" + name)
    }
    
    
    /// Upload local file in directory
    ///
    /// - parameter file:       URL of local file
    /// - parameter completion: completion handler. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    public func put(file:URL, completion:@escaping (AlgoDataFile?, Error?) -> Void) {
        let filename = file.lastPathComponent
        let dataFile = self.file(name: filename)
        dataFile.put(file: file) { (error) in
            if let _ = error {
                completion(nil, error)
            }
            else {
                completion(dataFile, nil)
            }
        }
    }
    
    
    /// Iterate over data files/directory in directory.
    ///
    /// - parameter object: handler takes one param
    /// * dataObject: An object in directory. It can be data file or directory.
    /// - parameter completion: completion handler. It will be invoked when iteration completes or fails. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    /// - returns: Data listing reference
    public func forEach(_ object:@escaping AlgoDataListingHandler, completion:@escaping AlgoSimpleCompletionHandler) -> AlgoDataListing {
        let listing = AlgoDataListing(client: client, path: getUrl())
        listing.incFile = true
        listing.incDir = true
        listing.forEach(handler: object, completion: completion)
        return listing
    }
    
    /// Iterate over data directory in current directory.
    ///
    /// - parameter object: handler takes one param
    /// * dataObject: An directory object in directory.
    /// - parameter completion: completion handler. It will be invoked when iteration completes or fails. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    /// - returns: Data listing reference
    public func forEach(dir:@escaping (AlgoDataDirectory?) -> Void, completion:@escaping AlgoSimpleCompletionHandler) -> AlgoDataListing {
        let listing = AlgoDataListing(client: client, path: getUrl())
        listing.incFile = false
        listing.incDir = true
        listing.forEach(handler: { (dataObject) in
            dir(dataObject as? AlgoDataDirectory)
            }, completion: completion)
        return listing
    }
    
    
    /// Iterate over data files in directory.
    ///
    /// - parameter object:     handler take one param
    /// * dataObject: An object in directory. It can be data file or directory.
    /// - parameter completion: completion handler. It will be invoked when iteration completes or fails. It takes one parameter
    /// * error: An error object that indicates why the request failed, or nil if the request was successful.
    /// - returns: Data listing reference
    public func forEach(file:@escaping (AlgoDataFile?) -> Void, completion:@escaping AlgoSimpleCompletionHandler) -> AlgoDataListing {
        let listing = AlgoDataListing(client: client, path: getUrl())
        listing.incFile = true
        listing.incDir = false
        listing.forEach(handler: { (dataObject) in
            file(dataObject as? AlgoDataFile)
            }, completion: completion)
        return listing
    }
    
    
}

public class AlgoDataListing {
    var client: AlgoAPIClient
    public var path: String
    var page:[String:Any]?
    var marker: String?
    var handler: AlgoDataListingHandler?
    public var incFile: Bool
    public var incDir: Bool
    
    init(client: AlgoAPIClient, path: String) {
        self.client = client;
        self.path = path;
        incFile = false;
        incDir = false;
    }
    
    func forEach(handler: @escaping AlgoDataListingHandler, completion: @escaping AlgoSimpleCompletionHandler ) {
        self.handler = handler
        self.loadNextPage(completion: completion)
    }
    
    func loadNextPage(completion: @escaping AlgoSimpleCompletionHandler) {
        var options = [String:String]()
        if marker != nil {
            options["marker"] = marker
        }
        _ = client.send(method: .GET, path: path, data: AlgoStringEntity(entity:""), options: options) { respData in
            if let error = respData.error {
                completion(error)
            }
            else {
                do {
                    try self.page = respData.getJSON()
                    if self.incFile {
                        if let fileArray = self.page?["files"] as? [Any] {
                            for obj in fileArray {
                                if let file = obj as? [String:Any] {
                                    let path = self.path + "/" + (file["filename"] as! String)
                                    let dataFile = AlgoDataFile(client: self.client, dataUrl: path)
                                    self.handler?(dataFile)
                                }
                            }
                        }
                    }
                    
                    if self.incDir {
                        if let dirArray = self.page?["files"] as? [Any] {
                            for obj in dirArray {
                                if let dir = obj as? [String:Any] {
                                    let path = self.path + "/" + (dir["filename"] as! String)
                                    let dataDir = AlgoDataDirectory(client: self.client, dataUrl: path)
                                    self.handler?(dataDir)
                                }
                            }
                        }
                    }
                    
                    if let marker = self.page?["marker"] as? String {
                        self.marker = marker
                        self.loadNextPage(completion: completion)
                        return;
                    }
                    
                    completion(respData.error)
                } catch  {
                    completion(respData.error ?? AlgoError.UnknownError)
                }
            }
        }
    }
}


