//
//  BouncesContentView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class BouncesContentView: BasicContentView {

    public var duration = 0.175
    public var animationScaleValues = [1.0, 1.1, 0.94, 1.08, 0.98, 1.02, 1.0]

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }

    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = self.animationScaleValues
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
}
