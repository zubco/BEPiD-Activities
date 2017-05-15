//
//  ShakeExtension.swift
//  RPJay - character manager
//
//  Created by Rafael Tomaz Prado on 05/04/17.
//  Copyright © 2017 Juliane Vianna. All rights reserved.
//

import Foundation
import UIKit

//An extension that performs a shake animation on the view. Used to indicate needed action upon the view.
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
