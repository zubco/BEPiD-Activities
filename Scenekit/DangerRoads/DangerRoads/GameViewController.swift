//
//  GameViewController.swift
//  DangerRoads
//
//  Created by Gustavo Lima on 18/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {

    let game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScenes()
        
        game.setup()
        
        //tweak physics
        game.scnView.scene!.physicsWorld.speed = 4.0
        
        //plug game logic
        game.scnView.delegate = game
    }
    
    func setupScenes() {
        
        let scnView = self.view as! SCNView!
        
        let scene = SCNScene(named: "art.scnassets/levels/level1.scn")!
        
        // set the scene to the view
        scnView?.scene = scene
        
        if let scene = SKScene(fileNamed: "art.scnassets/levels/overlay.sks") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
        
            scene.isUserInteractionEnabled = false
            
            scnView?.overlaySKScene = scene
        }
        
        game.scnView = scnView
    }
    
    
    @IBAction func screenTap(_ sender: UITapGestureRecognizer) {
        
        let touchLocation = sender.location(in: self.view)

        if touchLocation.x < self.view.bounds.size.width / 2 {
            
            // Left side of the screen
            game.vehicleSteering = 10.0
        
        } else {
            
            // Right side of the screen
            game.vehicleSteering = -10.0
        }
        
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self.view)
        
        if touchLocation.x < self.view.bounds.size.width / 2 {
            // Left side of the screen
            
            self.game.vehicleSteering = .pi / 8
            
        } else {
            // Right side of the screen
            
            self.game.vehicleSteering = -.pi / 8
        }
        
        if touches.count > 1 {
            self.game.engineForce = -400
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        self.game.vehicleSteering = 0
        self.game.engineForce = 400
    }

    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}



