//
//  AlgoOptions.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/8/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

public enum AlgoOption {
    case Timeout(Int)
    case Stdout(Bool)
    case Custom(String, String)
    
    public var value:String {
        switch self {
        case .Timeout(let time):
            return String(time)
        case .Stdout(let enabled):
            return String(enabled)
        case .Custom(_, let value):
            return value
        }
    }
    
    public var key:String {
        switch self {
        case .Timeout(_):
            return "timeout"
        case .Stdout(_):
            return "stdout"
        case .Custom(let key, _):
            return key
        }
    }
    
}
