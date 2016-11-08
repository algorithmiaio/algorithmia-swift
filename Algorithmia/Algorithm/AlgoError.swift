//
//  AlgoError.swift
//  AlgorithmiaSwiftDemo
//
//  Created by Erik Ilyin on 11/3/16.
//  Copyright © 2016 algorithmia. All rights reserved.
//

import Foundation

enum AlgoError : Error {
    case UnknownError
    case DataError(String)
    case ProcessError(String)
    
    var localizedDescription: String {
        switch self {
        case .DataError(let message):
            return message
        case .ProcessError(let message):
            return message
        case .UnknownError:
            return "Unknown Error"
        }
    }
}
