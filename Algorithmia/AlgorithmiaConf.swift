//
//  AlgorithmiaConf.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/2/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

public class Algo {
    public static let SWIFT_VERSION    = "3.0"
    public static let CLIENT_VERSION   = "1.0"
    public static let apiBaseUrl       = ProcessInfo.processInfo.environment["ALGORITHMIA_API"] ?? "https://api.algorithmia.com"
    static let DATA_BASE_PATH   = "v1/connector"
}
