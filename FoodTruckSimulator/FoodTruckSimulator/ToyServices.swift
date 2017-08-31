//
//  ToyServices.swift
//  FoodTruckSimulator
//
//  Created by SERGIO J RAFAEL ORDINE on 17/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class ToyServices {
    
    
    /// This function simulates the preparation of a gift toy
    /// Imagine this as a long duration task...
    ///
    /// - Returns: Image of the gift toy
    static func prepareToy() -> UIImage! {
        var image:UIImage!
        
        let url = URL(string: "https://media.lastnightoffreedom.co.uk/images/shop/1/344/344_101_1.jpg")
        if let imageURL = url {
            
            let data = try? Data(contentsOf: imageURL )
            if let imageData = data {
                
                let baseImage = UIImage(data: imageData)
                
                let size = baseImage!.size
                
                //Create a CGImage cloning the downloaded image
                let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
                let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
                let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
                
                //Create the circular mask
                context?.addArc(center: CGPoint(x: CGFloat(size.width/2.0),y:CGFloat(size.height/2.0)), radius: 500, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: false)
                context?.closePath();
                context?.clip();
                
                context?.draw((baseImage?.cgImage)!, in: CGRect(x: 0,y: 0,width: size.width, height: size.height))
                
                let imageMasked:CGImage = (context?.makeImage())!;
                
                
                image = UIImage(cgImage: imageMasked)
                
                UIGraphicsEndImageContext();
                
            }
        }
        
        return image
    }
    
    
    /// This function simulates assembling the toy with the sandwich
    ///
    /// - Parameters:
    ///   - order: The kitchen original order
    ///   - toyImage: A prepared toy (image) to assemble on the order
    /// - Returns: The final order
    static func assembleToy(_ order:Order, toyImage:UIImage!) -> Order {
        let sandwichImage = order.sandwichImage
        
        if (sandwichImage != nil && toyImage != nil) {
            UIGraphicsBeginImageContextWithOptions(sandwichImage!.size, true, 0.0);
            // Get context
            let context = UIGraphicsGetCurrentContext();
            // Push context to make it current
            // (need to do this manually because we are not drawing in a UIView)
            UIGraphicsPushContext(context!);
            
            //Draw the original image
            sandwichImage!.draw(in: CGRect(x: 0,y: 0,width: sandwichImage!.size.width, height: sandwichImage!.size.height))
            
            //Draw the toy image over the sandwich image) - 1/3rd scale
            let width = (sandwichImage?.size.width)! / 3.0
            let height = (sandwichImage?.size.height)! / 3.0
            let size = min(width, height)
            toyImage!.draw(in: CGRect(x: 0,y: 0,width:size , height:size ))
            
            // pop context
            UIGraphicsPopContext();
            
            let  finalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            //Recreate the order to use final image
            let finalOrder = Order(ticketNumber: order.ticketNumber, sandwichImage: finalImage)

            return finalOrder
            
        } else {
            return order
        }
        
    }

}
