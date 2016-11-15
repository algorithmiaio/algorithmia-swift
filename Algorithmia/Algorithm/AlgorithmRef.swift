//
//  AlgorithmRef.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/1/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class AlgorithmRef {
    let algoUri:String
    init(algoUri:String) {
        self.algoUri = algoUri.replacingOccurrences(of: "^algo://|^/", with: "", options: .regularExpression)
    }
    func getPath() -> String {
        return "v1/algo/" + algoUri
    }
    
    func toString() -> String {
        return "algo://" + algoUri
    }
}
