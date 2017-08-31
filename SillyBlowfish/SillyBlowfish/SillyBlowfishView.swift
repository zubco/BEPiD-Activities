//
//  SillyBlowfishView.swift
//  SillyBlowfish
//
//  Created by SERGIO J RAFAEL ORDINE on 16/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit
import AVFoundation

enum MouthAnimationDirection:Int {
    case none = 0
    case bored = 1
    case smiling = 2
    case loop = 3
}


@IBDesignable
class SillyBlowfishView: UIView {
    
    
    // MARK:- Constants
    
    fileprivate static let BlowfishBodyAnimationTime = 0.1
    fileprivate static let BlowfishMouthAnimationTime = 0.05
    fileprivate static let EyeAnimationTime = 0.2
    
    fileprivate static let EyeSizeProportion:CGFloat = 0.043
    
    //MARK: - Attributes
    
    private var _frame = 0
    private var _size = 0
    private var _type = 0
    
    fileprivate var isMouthOpening:Bool = false
    public var isMouthTalking:Bool = false
    
    fileprivate var leftEye: EyeLayer?
    fileprivate var rightEye: EyeLayer?
    fileprivate var eyePositions: SillyBlowfishEyes?
    
    
    fileprivate var bodyAnimationTimer:Timer?
    fileprivate var mouthAnimationTimer:Timer?
    
    fileprivate var mouthAnimationDirection:MouthAnimationDirection = .none
    
    
    fileprivate var fartPlayer:AVAudioPlayer?
    fileprivate var easterEggPlayer:AVAudioPlayer?
    
    fileprivate let sounds = ["sound1","sound2","sound3","sound4","sound5","sound6","sound7"]
    
    
    //MARK: - Interface Builder Properties
    
    @IBInspectable
    
    /// Current blowfish size (how inflated it is)
    public var currentSize:Int {
        get {
            return _size
        }
        set (newValue) {
            let repository = SpriteImageRepository.sharedRepository
            
            if repository.sizeIsValid(newValue) {
                _size = newValue
            }
        }
    }
    
    @IBInspectable
    
    /// Current blowfish frame (animation)
    public var currentFrame:Int  {
        get {
            return _frame
        }
        set (newValue) {
            let repository = SpriteImageRepository.sharedRepository
            
            if repository.frameIsValid(newValue) {
                _frame = newValue
            }
        }
    }
    
    @IBInspectable
    
    
    /// Current mouth image (from closed to smiling)
    public var currentMouth:Int  {
        get {
            return _type
        }
        set (newValue) {
            let repository = SpriteImageRepository.sharedRepository
            
            if repository.mouthTypeIsValid(newValue) {
                _type = newValue
            }
        }
    }

    

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInitialization()
    }
    
    
    
    private func viewInitialization() {
        
        //Ensue that sprite repository was instantiated and loaded
        _ = SpriteImageRepository.sharedRepository
        
        //Set eyes relative positioning
        eyePositions = SillyBlowfishEyes(
            left: CGRect(x:0.556,y:0.117,width:0.169,height:0.269) ,
            right: CGRect(x:0.726,y:0.113,width:0.152,height:0.274))
        
        //Set sound players
        if let fartSoundPath = Bundle.main.path(forResource: "fart", ofType: "mp3") {
            
            let fartSoundURL = URL(fileURLWithPath: fartSoundPath)
        
            do {
                self.fartPlayer = try AVAudioPlayer(contentsOf: fartSoundURL)
            } catch {
                print("Unable to load sound")
            }
        }
        
    }
    
    // MARK: - Draw and Layout Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Remove previously inserted sublayers
        self.layer.sublayers = nil
        
        //Add eye layers

        if let eyePositioning = eyePositions {
            
            let bounds = imageBounds(self.bounds)
            let eyeSize = bounds.size.width * SillyBlowfishView.EyeSizeProportion
            
            
            let eyes = eyePositioning.eyePositions(rect: bounds)
            
            let leftEyeCenter = SillyBlowfishEyes.rectCenter(rect: eyes.left)
            let rightEyeCenter = SillyBlowfishEyes.rectCenter(rect: eyes.right)
            
            self.leftEye = EyeLayer()
            self.leftEye!.frame = CGRect(x: leftEyeCenter.x - eyeSize / 2.0, y: leftEyeCenter.y - eyeSize / 2.0, width: eyeSize, height: eyeSize)
            
            
            self.rightEye = EyeLayer()
            self.rightEye!.frame = CGRect(x: rightEyeCenter.x - eyeSize / 2.0, y: rightEyeCenter.y - eyeSize / 2.0, width: eyeSize, height: eyeSize)
            
            self.layer.addSublayer(leftEye!)
            self.layer.addSublayer(rightEye!)
            
            self.leftEye!.setNeedsDisplay()
            self.rightEye!.setNeedsDisplay()
            
        }
       
        
        
    }
    
    override func draw(_ rect: CGRect) {
       
        let repository = SpriteImageRepository.sharedRepository
        
        let bodyImage = repository.spriteImageFor(frame: currentFrame,size: currentSize)
        let mouthImage = repository.mouthImageFor(type: currentMouth)
        
        //scale image to fit view
        if let body = bodyImage, let mouth = mouthImage {

            let boundingRect = imageBounds(rect)
            
            body.draw(in: boundingRect)
            mouth.draw(in: boundingRect)

            
        }
        
    }
    
    
    // MARK: - Auxiliary Methods
    
    /// Retrieve the blowfish bounds (actual size) within its encompassing view
    /// The image tries to ocuppy the maximum side in this view, respecting the image aspect ratio
    ///
    /// - Parameter rect: The encompassing view bounds (view size)
    /// - Returns: The blowfish bounds (considering it aspect ratio)
    fileprivate func imageBounds(_ rect: CGRect) -> CGRect {
        
        let repository = SpriteImageRepository.sharedRepository
        let bodyImage = repository.spriteImageFor(frame: currentFrame,size: currentSize)
        
        if let body = bodyImage {
            let widthRatio = rect.size.width / body.size.width
            let heightRatio = rect.size.height / body.size.height
            
            let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
            
            let actualWidth = body.size.width * ratio
            let actualHeight = body.size.height * ratio
            
            let boundingRect = CGRect(x: 0,y: 0,width: actualWidth,height: actualHeight)
            
            return boundingRect

        }
        
        return CGRect(x: 0, y: 0, width: 0, height: 0)
        
    }
    
}

// MARK: - Fish Animation
extension SillyBlowfishView {
    
    
    /// Start the blowfish animation (swimming)
    public func startAnimating() {
        
        self.bodyAnimationTimer?.invalidate()
        
        self.bodyAnimationTimer = Timer(timeInterval: SillyBlowfishView.BlowfishBodyAnimationTime, target: self, selector: #selector(SillyBlowfishView.advanceFrame), userInfo: nil, repeats: true)
        
        RunLoop.current.add(self.bodyAnimationTimer!, forMode: .commonModes)
        
    }
    
    
    /// Start taking the fish for a walking (or swimming :-P)
    public func startFollowing() {
        self.stopMouthAnimation()
        self.mouthAnimationDirection = .smiling
        
        animateMouth()
    }
    
    /// Finish taking the fish for a walking (or swimming :-P)
    public func stopFollowing() {
        self.stopMouthAnimation()
        self.mouthAnimationDirection = .bored
        
        animateMouth()
    }
    
    /// Start the fish talking animation
    public func startTalking() {
        stopMouthAnimation()
        mouthAnimationDirection = .loop
        isMouthTalking = true
        
        animateMouth()
    }
    
    
    /// Chjanhe the blowfish image to match its "inflation" scale
    ///
    /// - Parameter scale: The scale represents how "inflated" the blowfish is
    public func inflate(scale:CGFloat) {
        
        var size = Int(scale)
        
        if (size >= SpriteImageRepository.BlowfishSizes) {
            size = SpriteImageRepository.BlowfishSizes - 1
        }
        
        self.currentSize = size
        
        self.setNeedsDisplay()
    }
    
    
    //MARK: - Auxiliary Methods
    
    
    /// Start animating the mouth (according to its state)
    private func animateMouth() {
        self.mouthAnimationTimer = Timer(timeInterval: SillyBlowfishView.BlowfishMouthAnimationTime, target: self, selector: #selector(SillyBlowfishView.advanceMouthFrame), userInfo: nil, repeats: true)
        RunLoop.current.add(self.mouthAnimationTimer!, forMode: .commonModes)
    }
    
    
    /// Animate the blowfish frame (rotating if needed)
    @objc
    private func advanceFrame() {
        if (self.currentFrame == SpriteImageRepository.BlowfishFrames - 1) {
            self.currentFrame = 0
        } else {
            self.currentFrame += 1
        }
        
        OperationQueue.main.addOperation { 
             self.setNeedsDisplay()
        }
       
    }
    
    
    /// Advance the mouth frame (reverting if needed)
    @objc
    private func advanceMouthFrame() {
        
        switch (self.mouthAnimationDirection) {
            case .bored:
                if (currentMouth <= 0) {
                    self.currentMouth = 0
                    self.stopMouthAnimation()
                } else {
                    self.currentMouth -= 1
                }
            case .smiling:
                if (currentMouth >= SpriteImageRepository.MouthTypes - 1) {
                        self.currentMouth = SpriteImageRepository.MouthTypes - 1
                    self.stopMouthAnimation()
                } else {
                     self.currentMouth += 1
                }
            case .loop:
                if (isMouthOpening) {
                    if (currentMouth >= SpriteImageRepository.MouthTypes - 1) {
                        self.isMouthOpening = false
                        self.currentMouth = SpriteImageRepository.MouthTypes - 1
                    } else {
                        self.currentMouth += 1
                    }
                } else {
                    if (currentMouth <= 0) {
                        isMouthOpening = true
                        if (!isMouthTalking) {
                            stopMouthAnimation()
                        }
                        currentMouth = 0
                    } else {
                        currentMouth -= 1
                    }
                }
            case .none:
                stopMouthAnimation()
        }
        
    }
    
    
    /// Stop animating the blowfish's mouth
    private func stopMouthAnimation() {
        self.mouthAnimationTimer?.invalidate()
    }
    
    
}

//MARK: - Sound Methods
extension SillyBlowfishView: AVAudioPlayerDelegate {
    
    
    /// Nature sometimes has its call.
    public func pullMyFinger() {
        self.fartPlayer?.play()
    }
    
    /// It is an easter egg! I would be a spoiler if I explain this...
    public func easterEgg() {
        
        //Not playing another sound
        if ((easterEggPlayer == nil) || !(easterEggPlayer!.isPlaying)) {
            
            let selectedSound = Int(arc4random()) % self.sounds.count
            
            let easterEggSound = "sound\(selectedSound)"
            
            if let easterEggPath = Bundle.main.path(forResource: easterEggSound, ofType: "caf") {
                let easterEggSoundURL = URL(fileURLWithPath: easterEggPath)
                do {
                        self.easterEggPlayer = try AVAudioPlayer(contentsOf: easterEggSoundURL)
                        self.easterEggPlayer?.delegate = self
                        self.easterEggPlayer?.play()
                        self.startTalking()
                } catch {
                        print("Unable to play sound")
                }
            }
            
        }
        
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isMouthTalking = false
    }
    
}


//MARK:- Eye Animation
extension SillyBlowfishView {
    
    
    /// Makes the blowfish look at a given position momentaneously
    ///
    /// - Parameter position: Position to look at (on the blowfish coordinate system)
    public func lookPosition(position:CGPoint) {
        
        if let eyePositioning = eyePositions {
            let bounds = imageBounds(self.bounds)
        
            let eyes = eyePositioning.eyePositions(rect: bounds)
            
            let leftEyeCenter = SillyBlowfishEyes.rectCenter(rect: eyes.left)
            let rightEyeCenter = SillyBlowfishEyes.rectCenter(rect: eyes.right)
            
            
            let leftAnimation = animateEye(eye: leftEye, bounds: eyes.left, center: leftEyeCenter, to: position)
            let rightAnimation = animateEye(eye: rightEye, bounds: eyes.right, center: rightEyeCenter, to: position)
            
            addAnimation(eye: leftEye, animation: leftAnimation)
            addAnimation(eye: rightEye, animation: rightAnimation)
        }
        
    }
    
    
    /// Makes the blowfish look at a pair of positions momentaneously, one wih each eye (I hope it 
    /// does not mess with his eyesight...)
    ///
    /// - Parameters:
    ///   - position1: Position 1 to look at (on the blowfish coordinate system)
    ///   - position2: Position 2 to look at (on the blowfish coordinate system)
    public func lookPosition(first position1:CGPoint, second position2: CGPoint) {
        
        if let eyePositioning = eyePositions {
            
            let bounds = imageBounds(self.bounds)
            
            let eyes = eyePositioning.eyePositions(rect: bounds)
            
            var leftPosition:CGPoint
            var rightPosition:CGPoint
            
            //Choose left or right eye
            if (position1.x < position2.x)
            {
                leftPosition = position1;
                rightPosition = position2;
                
            } else {
                leftPosition = position2;
                rightPosition = position1;
            }
            
            let leftEyeCenter = SillyBlowfishEyes.rectCenter(rect: eyes.left)
            let rightEyeCenter = SillyBlowfishEyes.rectCenter(rect: eyes.right)
            
            let leftAnimation = animateEye(eye: leftEye, bounds: eyes.left, center: leftEyeCenter, to: leftPosition)
            let rightAnimation = animateEye(eye: rightEye, bounds: eyes.right, center: rightEyeCenter, to: rightPosition)
            
            addAnimation(eye: leftEye, animation: leftAnimation)
            addAnimation(eye: rightEye, animation: rightAnimation)
            
        }
        
    }
    
    
    //MARK: - Auxiliary animation Methods
    
    
    /// Add an animation to a given eye layer
    ///
    /// - Parameters:
    ///   - eye: The target Eye Layer
    ///   - animation: The animation to be applied
    private func addAnimation(eye:EyeLayer?, animation:CABasicAnimation?) {
        if let validAnimation = animation {
            eye?.add(validAnimation, forKey: "transform")
        }
    }
    
    
    
    /// Creates an eye movement animation
    ///
    /// - Parameters:
    ///   - eyeLayer: The target eye layer
    ///   - bounds: The eyeball bounds
    ///   - center: The center of the eyeball
    ///   - to: Position to look at
    /// - Returns: The animation built based on the given parameters
    private func animateEye(eye eyeLayer:EyeLayer?,bounds:CGRect, center:CGPoint, to:CGPoint) -> CABasicAnimation? {
        
        guard let eye = eyeLayer else {
            return nil
        }
        
        let results = GeometryUtil.intersectEllipse(bounds: bounds, startAt: to, endAt: center)

        let intersectPoint = (results.count > 0) ? GeometryUtil.closestPoint(list: results, to: to) : to
        
        return createEyeAnimation(to:intersectPoint, eye:eye, autoreverse:true)
        
    }
    
    
    /// Create the eye movement animation
    ///
    /// - Parameters:
    ///   - to: Final position to look at
    ///   - eye: The target eye layer
    ///   - autoreverse: Whether the animation shall reverse or not
    /// - Returns: The animation built based on the given parameters
    private func createEyeAnimation(to:CGPoint, eye:EyeLayer, autoreverse:Bool) -> CABasicAnimation {
        
        let dx = deltaX(to: to, center: eye.frame.origin, size: eye.frame.size)
        let dy = deltaY(to: to, center: eye.frame.origin, size: eye.frame.size)
        
        let transform = CATransform3DMakeTranslation(dx, dy, 0)
        
        //creates an autoreverse animation for eye movement
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.autoreverses = true
        animation.toValue = transform
        animation.duration = SillyBlowfishView.EyeAnimationTime
        
        return animation
        
    }
    
    
    /// The variation on X coordinates between two given points
    ///
    /// - Parameters:
    ///   - to: Final position
    ///   - center: Center position
    ///   - size: Eyeball bounds
    /// - Returns: The variation on X coordinates
    private func deltaX(to:CGPoint, center:CGPoint, size:CGSize) -> CGFloat {
        
        var deltaX = to.x - center.x
        
        if (deltaX > 0) {
            deltaX -= size.width
        }
        
        return deltaX
        
    }
    
    /// The variation on Y coordinates between two given points
    ///
    /// - Parameters:
    ///   - to: Final position
    ///   - center: Center position
    ///   - size: Eyeball bounds
    /// - Returns: The variation on Y coordinates
    private func deltaY(to:CGPoint, center:CGPoint, size:CGSize) -> CGFloat {
        
        var deltaY = to.y - center.y
        
        if (deltaY > 0) {
            deltaY -= size.height
        }
        
        return deltaY
    }
    
}


