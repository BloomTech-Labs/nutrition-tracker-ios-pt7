//
//  NetworkError.swift
//  Nutrivurv
//
//  Created by Dillon P on 6/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noEncode
    case noDecode
    case serverError
    case noToken
    case objectInitFailed
}
