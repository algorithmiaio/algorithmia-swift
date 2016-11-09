//
//  AlgoOptions.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/8/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

enum AlgoOption {
    case Timeout(Float)
    case Stdout(Bool)
    case Output(String)
    
    var value:String {
        switch self {
        case .Timeout(let time):
            return String(time)
        case .Stdout(let enabled):
            return String(enabled)
        case .Output(let output):
            return output
        }
    }
    
    var key:String {
        switch self {
        case .Timeout(_):
            return "timeout"
        case .Stdout(_):
            return "stdout"
        case .Output(_):
            return "output"
        }
    }
    
}
