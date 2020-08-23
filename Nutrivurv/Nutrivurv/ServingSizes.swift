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
    let objectWillChange = PassthroughSubject<[Measure], Never>()
    
    @Published var measures: [Measure] = [] {
        willSet {
            objectWillChange.send(newValue)
        }
    }
}
