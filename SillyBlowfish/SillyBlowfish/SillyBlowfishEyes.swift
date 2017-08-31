//
//  SillyBlowfishEyes.swift
//  SillyBlowfish
//
//  Created by SERGIO J RAFAEL ORDINE on 17/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class SillyBlowfishEyes {
    
    
    // MARK: - Attributes
    public var leftEye: CGRect
    public var rightEye: CGRect
    //public var leftEyeCenter: CGPoint
    
    //public var rightEyeCenter: CGPoint
    
    
    // MARK: - Initialization
    
    init(left:CGRect, right:CGRect) {
        leftEye = left
        rightEye = right
    }
    
    // MARK:- Positioning methods

    func eyePositions(rect:CGRect) -> (left:CGRect, right:CGRect) {
        let leftEye = proportionalPositioning(bounds: rect, reference: self.leftEye)
        let rightEye = proportionalPositioning(bounds: rect, reference: self.rightEye)
        
        return (leftEye,rightEye)
    }
    
    public static func rectCenter(rect:CGRect) -> CGPoint {
        
        return CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + (rect.size.height / 2.0))
        
    }
    
    //MARK:- Auxiliary Methods
    
    private func proportionalPositioning(bounds rect:CGRect, reference referenceRect:CGRect) -> CGRect {
        
         return CGRect(x: rect.size.width * referenceRect.origin.x , y: rect.size.height * referenceRect.origin.y, width: rect.size.width * referenceRect.size.width, height: rect.size.height * referenceRect.size.height)
        
        
    }
    
    
}
