//
//  ViewExtensions.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/21/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

public extension View {
  func fillParent(alignment: Alignment = .center) -> some View {
    self
      .frame(
        minWidth: 0,
        maxWidth: .infinity,
        minHeight: 0,
        maxHeight: .infinity,
        alignment: alignment
    )
  }
}
