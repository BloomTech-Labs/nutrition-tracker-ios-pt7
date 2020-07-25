//
//  UIView Extensions.swift
//  Nutrivurv
//
//  Created by Dillon on 7/23/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//
import UIKit
import Foundation

public extension UIView {
    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -12),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 12),
            topAnchor.constraint(equalTo: view.topAnchor, constant: -14),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 14)
        ])
    }
}
