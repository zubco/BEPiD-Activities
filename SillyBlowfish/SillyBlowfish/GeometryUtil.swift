//
//  GeometryUtil.swift
//  SillyBlowfish
//
//  Created by SERGIO J RAFAEL ORDINE on 17/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class GeometryUtil {
    
    
    /// Get the points where a line segment (startPoint,endPoint) intersects an ellipse.
    ///
    /// - Parameters:
    ///   - ellipseRect: The ellipse bounding rectangle
    ///   - startPoint: Line segment start point
    ///   - endPoint: Line segment end point
    /// - Returns: List of intersection points (from 0 to 2).
    static func intersectEllipse(bounds ellipseRect:CGRect, startAt startPoint:CGPoint, endAt endPoint:CGPoint) -> [CGPoint] {
        
        
        var intersectPoints = [CGPoint]()
        
        var firstPoint = startPoint
        var secondPoint = endPoint
        var bounds = ellipseRect
        
        guard   ((ellipseRect.size.width != 0) &&
                (ellipseRect.size.height != 0) &&
                (firstPoint != secondPoint)) else {
                    
                return intersectPoints
        }
        
        //Translate to center ellipse in origin
        let cx = bounds.origin.x + bounds.size.width / 2.0
        let cy = bounds.origin.y + bounds.size.height / 2.0
        
        
        bounds.origin.x -= cx
        bounds.origin.y -= cy
        
        
        firstPoint.x -= cx
        firstPoint.y -= cy
        secondPoint.x -= cx
        secondPoint.y -= cy
        
        
        //Get the semimajor and semiminor axes
        let a = bounds.size.width / 2.0
        let b = bounds.size.height / 2.0
        
        //Calculate the quadratic parameters
        let A = ((secondPoint.x - firstPoint.x) * (secondPoint.x - firstPoint.x) / a / a) +  ((secondPoint.y - firstPoint.y) * (secondPoint.y - firstPoint.y) / b / b)
        
        let B = ((2 * firstPoint.x * (secondPoint.x - firstPoint.x)) / a / a) + ((2 * firstPoint.y * (secondPoint.y - firstPoint.y)) / b / b)
        
        let C = (firstPoint.x * firstPoint.x / a / a) + (firstPoint.y * firstPoint.y / b / b) - 1
        
        
        //Solve the quadratic equation
        let results = quadraticEquation(a: A, b: B, c: C)

        
        //Calculate points based on equation result(s)
        intersectPoints = results.map{ (result) -> CGPoint in
            CGPoint(
                x: firstPoint.x + ((secondPoint.x - firstPoint.x) * result) + cx,
                y: firstPoint.y + ((secondPoint.y - firstPoint.y) * result) + cy)
        }
        

        
        return intersectPoints
    }
    
    
    
    /// Solves a quadratic equation a*x^2 + b*x + c = 0
    ///
    /// - Parameters:
    ///   - a: a
    ///   - b: b
    ///   - c: c
    /// - Returns: An array of x's values that satisfies the equation. Returns from 0 to 2 CGFloat numbers
    static func quadraticEquation(a:CGFloat, b:CGFloat, c: CGFloat) -> [CGFloat] {
        
        var results = [CGFloat]()
        
        //Calculate the discriminant (delta)
        let discriminant = b * b - 4 * a * c
        
        //Solve the quadratic equation
        if (discriminant == 0) {
            let result = -b / (2 * a)
            
            results.append(result)
            
        } else if (discriminant > 0) {
            let result1 = (-b + sqrt(discriminant)) / (2 * a)
            let result2 = (-b - sqrt(discriminant)) / (2 * a)
            
            results.append(result1)
            results.append(result2)
        }
        
        return results
        
    }
    
    
    
    /// The closest point in a list of points from another given point
    ///
    /// - Parameters:
    ///   - list: List of points
    ///   - to: Point to be compared
    /// - Returns: The closest point to **to** point in the given list
    static func closestPoint(list:[CGPoint], to:CGPoint) -> CGPoint {
        
        var result = to
        
        var minDistance = CGFloat.greatestFiniteMagnitude
        
        for point in list {
            let currentDistance = distance(from:point, to:to)
            if (currentDistance < minDistance) {
                minDistance = currentDistance
                result = point
            }
        }

        return result
    }
    
    
    static func distance(from:CGPoint, to:CGPoint) -> CGFloat {
        
        return sqrt((from.x - to.x)*(from.x - to.x) + (from.y - to.y)*(from.y - to.y))
        
    }
    

}
