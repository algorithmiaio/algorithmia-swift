//
//  AlgorithmiaConf.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/2/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

class Algo {
    static let SWIFT_VERSION    = "3.0"
    static let CLIENT_VERSION   = "1.0"
    static let apiBaseUrl       = ProcessInfo.processInfo.environment["ALGORITHMIA_API"] ?? "https://api.algorithmia.com"
    static let DATA_BASE_PATH   = "v1/connector"
}
