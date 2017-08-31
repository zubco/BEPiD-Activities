//
//  CustomGesture.swift
//  SillyBlowfish
//
//  Created by Rafael Tomaz Prado on 09/06/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit
import Foundation
import UIKit.UIGestureRecognizerSubclass

class CustomGestureRecognizer: UIGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.reset()
        super.touchesBegan(touches, with: event)
        if touches.count != 3{
            state = .failed
        }
        state = .began
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = .ended
        
        print("Touch ended!")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .failed{
            return
        }
        
        state = .changed
    }
}
