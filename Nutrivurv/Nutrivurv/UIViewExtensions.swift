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
            topAnchor.constraint(equalTo: view.topAnchor, constant: -12),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 12)
        ])
    }
    
    func pinWithNoPadding(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


public extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
