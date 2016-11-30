//
//  AlgoError.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/3/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

public enum AlgoError : Error {
    case UnknownError
    case DataError(String)
    case ProcessError(Int, String)
    
    public var localizedDescription: String {
        switch self {
        case .DataError(let message):
            return message
        case .ProcessError(let code, let message):
            return String(code)+" "+message
        case .UnknownError:
            return "Unknown Error"
        }
    }
}
