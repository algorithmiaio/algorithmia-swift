//
//  DataObject.swift
//  Algorithmia
//
//  Created by Erik Ilyin on 11/10/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgoDataObject {
    enum DataObjectType {
        case File
        case Directory
    }
    
    let path:String
    
    let client:AlgoAPIClient
    let dataType:DataObjectType
    
    init(client:AlgoAPIClient, dataUrl:String, type:DataObjectType) {
        self.client = client
        self.path = dataUrl.replacingOccurrences(of: "^data://|^/", with: "", options: .regularExpression)
        self.dataType = type
    }
    
}
