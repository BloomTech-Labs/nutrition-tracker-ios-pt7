//
//  HighlightableContentView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.

import UIKit

class HighlightableContentView: BackgroundContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let transform = CGAffineTransform.identity
        imageView.transform = transform.scaledBy(x: 1.15, y: 1.15)

    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
//        UIView.beginAnimations("small", context: nil)
//        UIView.setAnimationDuration(0.2)
//        let transform = imageView.transform.scaledBy(x: 0.8, y: 0.8)
//        imageView.transform = transform
//        UIView.commitAnimations()
//        completion?()
//    }
//    
//    override func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
//        UIView.beginAnimations("big", context: nil)
//        UIView.setAnimationDuration(0.2)
//        let transform = CGAffineTransform.identity
//        imageView.transform = transform.scaledBy(x: 1.15, y: 1.15)
//        UIView.commitAnimations()
//        completion?()
//    }
    
}
