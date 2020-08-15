//
//  Weight.swift
//  Nutrivurv
//
//  Created by Dillon on 8/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Combine
import SwiftUI

class Weight: ObservableObject {
    let objectWillChange = PassthroughSubject<[Double], Never>()
    
    @Published var weightReadings: [Double] = [0,0,0] {
        willSet {
            objectWillChange.send(newValue)
        }
    }
}
