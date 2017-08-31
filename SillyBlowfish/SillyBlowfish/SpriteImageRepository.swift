//
//  SpriteImageRepository.swift
//  SillyBlowfish
//
//  Created by SERGIO J RAFAEL ORDINE on 16/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit


class SpriteImageRepository {
    
    // MARK: - Constants
    public static let BlowfishSizes = 4
    private static let BlowfishImageWidth = 920
    private static let BlowfishImageHeight = 690
    
    private static let BlowfishFrameColumns = 4
    private static let BlowfishFrameRows = 3
    
    private static let MouthFrameColumns = 4
    private static let MouthFrameRows = 1
    
    public static let BlowfishFrames = 12
    public static let MouthTypes = 4

    
    //MARK: - Attributes
    
    private static let store = SpriteImageRepository()
    private var spriteArray = [[UIImage]]()
    private var mouthArray = [UIImage]()
    
    // MARK: - Singleton
    private init() {
        loadSpritesForPosition("Blowfish1")
        loadMouthForPosition("Mouth1")

    }
    
    public static var sharedRepository:SpriteImageRepository {
        get {
            return store
        }
    }
    
    // MARK: - Interface Methods
    
    func spriteImageFor(frame: Int, size: Int) -> UIImage? {
        
        guard (frameIsValid(frame) && sizeIsValid(size)) else {
            return nil
        }
        
        return self.spriteArray[size][frame]
        
    }
    
    
    func mouthImageFor(type:Int) -> UIImage? {
        
        guard (mouthTypeIsValid(type)) else {
            return nil
        }
        
        return self.mouthArray[type]
        
    }
    
    
    func frameIsValid(_ frame:Int)->Bool {
        return (frame >= 0 && frame < SpriteImageRepository.BlowfishFrames)
    }
    
    func sizeIsValid(_ size:Int) -> Bool {
        return (size >= 0 && size < SpriteImageRepository.BlowfishSizes)
    }
    
    func mouthTypeIsValid(_ type:Int) -> Bool {
        return (type >= 0 && type < SpriteImageRepository.MouthTypes)
    }
    
    
    // MARK: - Auxiliary Methods

    private func loadSpritesForPosition(_ mask:String) {
        
        
        for size in 0 ..< SpriteImageRepository.BlowfishSizes {
            
            let fileName = "\(mask)\(size+1)"
            let bundle = Bundle(for: SpriteImageRepository.self)
            let frameSetImage = UIImage(named: fileName, in: bundle, compatibleWith: nil)
     
            if let image = frameSetImage {
                let animationRectangle = CGRect(x:0,y:0,width:SpriteImageRepository.BlowfishImageWidth, height:SpriteImageRepository.BlowfishImageHeight)
                
                let frameset = SpriteUtil.createFrameSet(from: image, rect: animationRectangle, columns: SpriteImageRepository.BlowfishFrameColumns, rows: SpriteImageRepository.BlowfishFrameRows)
                
                 self.spriteArray.append(frameset)
                
            }
            
           
            
        }
        

    }
    
    private func loadMouthForPosition(_ fileName:String) {
        
        var sizeArray = [UIImage]()
        
        
        let bundle = Bundle(for: SpriteImageRepository.self)
        
        let frameSetImage = UIImage(named: fileName, in: bundle, compatibleWith: nil)
        
        if let image = frameSetImage {
            let animationRectangle = CGRect(x:0,y:0,width:SpriteImageRepository.BlowfishImageWidth, height:SpriteImageRepository.BlowfishImageHeight)
            
            let frameset = SpriteUtil.createFrameSet(from: image, rect: animationRectangle, columns: SpriteImageRepository.MouthFrameColumns, rows: SpriteImageRepository.MouthFrameRows)
            
            sizeArray = frameset
            
            self.mouthArray = sizeArray
        }
        
        
    }
    
}
