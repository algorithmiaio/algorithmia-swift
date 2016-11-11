//
//  AlgoOptions.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/8/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

enum AlgoOption {
    case Timeout(Int)
    case Stdout(Bool)
    case VoidOutput
    case Custom(String, String)
    
    var value:String {
        switch self {
        case .Timeout(let time):
            return String(time)
        case .Stdout(let enabled):
            return String(enabled)
        case .VoidOutput:
            return "void"
        case .Custom(_, let value):
            return value
        }
    }
    
    var key:String {
        switch self {
        case .Timeout(_):
            return "timeout"
        case .Stdout(_):
            return "stdout"
        case .VoidOutput:
            return "output"
        case .Custom(let key, _):
            return key
        }
    }
    
}
