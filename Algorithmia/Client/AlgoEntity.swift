//
//  AlgoReqeust.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgoEntity {
    var data:Data?
    func headers() -> [AlgoRequest.HTTPHeader] {
        return []
    }
    
    func body() -> Data? {
        return data
    }
    
    
}

class AlgoStringEntity:AlgoEntity {
    
    init(entity:String) {
        super.init()
        self.data = entity.data(using: .utf8)
    }
    
    override func headers() -> [AlgoRequest.HTTPHeader] {
        return [AlgoRequest.HTTPHeader.ContentType(AlgoRequest.MIMEType.TEXT_PLAIN.rawValue)]
    }
    
    override func body() -> Data? {
        return data
    }
}

class AlgoJSONEntity:AlgoEntity {
    
    init(plain:String) throws {
        super.init()
        self.data = plain.data(using: .utf8)
    }
    
    init(entity:Any) throws {
        super.init()
        if JSONSerialization.isValidJSONObject(entity) {
            throw AlgoError.DataError("Not valid Json object")
        }
        
        try self.data = JSONSerialization.data(withJSONObject: entity, options: [])
    }
    
    
    
    override func headers() -> [AlgoRequest.HTTPHeader] {
        return [AlgoRequest.HTTPHeader.ContentType(AlgoRequest.MIMEType.APPLICATION_JSON.rawValue)]
    }
    
    override func body() -> Data? {
        return data
       
    }
    
    
}

