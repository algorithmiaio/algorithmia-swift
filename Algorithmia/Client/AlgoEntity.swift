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
    var dataType:AlgoRequest.MIMEType
    init() {
        dataType = .TEXT_PLAIN
    }
    func headers() -> [AlgoRequest.HTTPHeader] {
        return [AlgoRequest.HTTPHeader.ContentType(dataType.rawValue)]
    }
    
    func body() -> Data? {
        return data
    }
    
    
}

class AlgoStringEntity:AlgoEntity {
    
    init(entity:String) {
        super.init()
        self.data = entity.data(using: .utf8)
        self.dataType = .TEXT_PLAIN
    }
    
    
}

class AlgoJSONEntity:AlgoEntity {
    
    init(plain:String) throws {
        super.init()
        self.data = plain.data(using: .utf8)
        self.dataType = .APPLICATION_JSON
    }
    
    init(entity:Any) throws {
        super.init()
        self.dataType = .APPLICATION_JSON
        if !JSONSerialization.isValidJSONObject(entity) {
            throw AlgoError.DataError("Not valid Json object")
        }
        
        try self.data = JSONSerialization.data(withJSONObject: entity, options: [])
    }
    
}

class AlgoBinaryEntity:AlgoEntity {
    
    init(data:Data) {
        super.init()
        self.data = data
        self.dataType = .APPLICATION_OCT
    }
    
}

