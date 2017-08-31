//
//  ViewController.swift
//  SillyBlowfish
//
//  Created by SERGIO J RAFAEL ORDINE on 16/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class SillyBlowfishViewController: UIViewController {

    @IBOutlet weak var fish: SillyBlowfishView!
    @IBOutlet weak var shell: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fish.startAnimating()
        
        let twoFingersTap = UITapGestureRecognizer(target: self, action: #selector(SillyBlowfishViewController.tapTwoFingers(_:)))
        twoFingersTap.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(twoFingersTap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SillyBlowfishViewController.longPress(_:)))
        self.fish.addGestureRecognizer(longPress)
        
        let twoFingersLongPress = UILongPressGestureRecognizer(target: self, action: #selector(SillyBlowfishViewController.twoFingersLongPress(_:)))
        twoFingersLongPress.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(twoFingersLongPress)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(SillyBlowfishViewController.pinch(_:)))
        self.view.addGestureRecognizer(pinch)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(SillyBlowfishViewController.rotate(_:)))
        self.view.addGestureRecognizer(rotate)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(SillyBlowfishViewController.pan(_:)))
        self.view.addGestureRecognizer(pan)
        
        let custom = CustomGestureRecognizer(target: self, action: #selector(SillyBlowfishViewController.custom(_:)))
        self.view.addGestureRecognizer(custom)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        let position = sender.location(in: self.fish)
        fish.lookPosition(position: position)
    }
    
    func tapTwoFingers(_ tap: UITapGestureRecognizer){
        let position1 = tap.location(ofTouch: 0, in: self.fish)
        let position2 = tap.location(ofTouch: 1, in: self.fish)
        fish.lookPosition(first: position1, second: position2)
    }
    
    func longPress(_ gesture:UILongPressGestureRecognizer){
        fish.pullMyFinger()
    }
    
    func twoFingersLongPress(_ gesture: UILongPressGestureRecognizer){
        fish.easterEgg()
    }
    
    func pinch(_ gesture:UIPinchGestureRecognizer){
        self.fish.inflate(scale: gesture.scale)
    }
    
    func rotate(_ gesture:UIRotationGestureRecognizer){
        let rotation = gesture.rotation
        self.shell.transform = self.shell.transform.rotated(by: rotation)
        gesture.rotation = 0
    }
    
    func pan(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.view)
        self.fish.transform = self.fish.transform.translatedBy(x: translation.x, y: translation.y)
        gesture.setTranslation(CGPoint.zero, in: self.view)
        
        if(gesture.state == .began){
            self.fish.startFollowing()
        }
        if(gesture.state == .ended){
            self.fish.stopFollowing()
        }
    }
    
    func custom(_ gesture: CustomGestureRecognizer){
    }
}

