//
//  EyeLayer.swift
//  SillyBlowfish
//
//  Created by SERGIO J RAFAEL ORDINE on 17/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class EyeLayer: CALayer {
    
    override func draw(in ctx: CGContext) {
        
        //Configure drawing
        ctx.setLineWidth(1.0)
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setFillColor(UIColor.black.cgColor)
        
        //Draw the eye (an ellipse)
        let rect = self.bounds
        ctx.addEllipse(in: rect)
        ctx.strokePath()
        ctx.fillEllipse(in: rect)
        
    }

}
