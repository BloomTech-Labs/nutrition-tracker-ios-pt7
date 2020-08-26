//
//  ServingSizes.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ServingSizes: ObservableObject {
    let objectWillChange = PassthroughSubject<[Any], Never>()
    
    // The Measure type is the type returned when decoding from the Edamam API
    @Published var edamamMeasures: [Measure] = [] {
        willSet {
            objectWillChange.send(newValue)
        }
    }
    
    @Published var nutrivurvBackendMeasurements: [Measurement] = [] {
        willSet {
            objectWillChange.send(newValue)
        }
    }
}
