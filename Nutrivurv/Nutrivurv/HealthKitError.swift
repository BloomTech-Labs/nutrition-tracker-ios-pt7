//
//  HealthKitError.swift
//  Nutrivurv
//
//  Created by Dillon on 8/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

enum HealthKitError: Error {
    case generalQueryError
    case dataNotAvailable
    case missingInformation
}
