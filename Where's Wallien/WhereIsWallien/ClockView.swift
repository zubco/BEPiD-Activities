//
//  ClockView.swift
//  WhereIsWallien
//
//  Created by Gustavo Lima on 28/04/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit


/// Implementar uma view que indique a contagem de tempo para
/// encontrar o Wallien. 
/// Pode ser contagem progressiva ou regressiva a sua escolha
@IBDesignable class ClockView: UIView {

    
    var time : Float = 0 {
        didSet{
             self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        ///Starts initial context:
        let context:CGContext! = UIGraphicsGetCurrentContext()
        
        // Sets rounded corners
        let marginPath = UIBezierPath(roundedRect: rect, cornerRadius: 14.0)
        // adds a clipping mask to the view
        marginPath.addClip()
        
        ///Saves initial context
        context.saveGState()
        
        let bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        bgColor.set()
        
        ///Saves context before painting the backgound
        context.saveGState()
        //Fills the background
        context.fill(rect)
        ///Restores previous context (to initial)
        context.restoreGState()
        
        //turns on antialiasing
        context.setShouldAntialias(true)
        
        let color:UIColor
        if self.time < 105{
            //Instantiates the blue color to be used on the clock
            color = UIColor(red: 0, green: 0.6, blue: 1, alpha: 1.0)
        }
        else{
            //Instantiates the red color to be used when time is running out
            color = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        }
        
        //Define the color on stroke context
        color.setStroke()
        
        //Defines the shadow color, offset and sets it on the context.
        let shadowColor = color.withAlphaComponent(0.8).cgColor
        let shadowOffset = CGSize(width: 1, height: 1)
        context.setShadow(offset: shadowOffset, blur: 3.5, color: shadowColor)
        
        //Creates the center of the view
        let center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        //Defines the circle path
        let circlePath = UIBezierPath(arcCenter: center, radius: 40, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        //Sets line width
        circlePath.lineWidth = 2
        
        ///Saves the circle drawing context
        context.saveGState()
        //Draws circle with the shadow
        circlePath.stroke()
        ///Restores previous context
        context.restoreGState()
        
        ///Saves context before painting the circle fill
        context.saveGState()
        
        var fillColor:UIColor
        if self.time < 105{
            //defines the fill color matching the stroke color
            fillColor = UIColor(red: 0, green: 0.6, blue: 1, alpha: 1.0)
        }
        else{
            //define the red fill color
            fillColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        }
        //Sets the color on the context
        fillColor.setFill()
        
        //Creates the circle center
        let fillCenter = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        //Calculates the amount to be filled
        let space = CGFloat(time * Float.pi/60.0)
        
        //defines the filling path (starting on top and filling clockwise)
        let fillPath = UIBezierPath(arcCenter: fillCenter, radius: 40, startAngle: 3 * .pi/2, endAngle: space - .pi/2, clockwise: true)
        
        ///Saves the context before filling
        context.saveGState()
        
        //Adds a line to the center, so it closes and fills properly
        fillPath.addLine(to: fillCenter)
        //Performs the filling
        fillPath.fill()
        ///Restores previous state
        context.restoreGState()
    }
}
