//
//  SpriteUtil.swift
//  SillyBlowfish
//
//  Created by SERGIO J RAFAEL ORDINE on 16/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class SpriteUtil {

    
    /// Create a set of frames from a given image
    ///
    /// - Parameters:
    ///   - image: The image that contains the frame map
    ///   - rect: Image map position within the image
    ///   - columns: Number of frame columns
    ///   - rows: Number of frame rows
    /// - Returns: Array with images clipped for each frame (from top left to bottom right, organized by rows)
    static func createFrameSet(from image:UIImage,rect:CGRect, columns: Int, rows: Int) -> [UIImage] {
        
        let frameWidth = rect.size.width / CGFloat(columns)
        let frameHeight = rect.size.height / CGFloat(rows)
        
        var frameset = [UIImage]()
        
        let offsetX = rect.origin.x
        let offsetY = rect.origin.y
        
        for i in 0 ..< columns {
            for j in 0 ..< rows {
                let frameRect = CGRect(x: offsetX + CGFloat(i) * frameWidth, y: offsetY + CGFloat(j) * frameHeight, width: frameWidth, height: frameHeight)
                
                let frameImageRef = image.cgImage!.cropping(to: frameRect)
                
                if (frameImageRef != nil) {
                    let frameImage = UIImage(cgImage: frameImageRef!)
                
                    frameset.append(frameImage)
                }
            
            }
        }
        
        return frameset
    }
    
}
