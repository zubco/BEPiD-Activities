//
//  GameViewController.swift
//  SceneKitTraining
//
//  Created by Rafael Tomaz Prado on 12/06/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    let game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScenes()
        game.setup()
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
        // Release any cached data, images, etc that aren't in use.
    }
    
    func setupScenes() {
        
        let scnView = self.view as! SCNView!
        
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        
        // set the scene to the view
        scnView?.scene = scene
        
//        if let scene = SKScene(fileNamed: "art.scnassets/levels/overlay.sks") {
//            // Set the scale mode to scale to fit the window
//            scene.scaleMode = .aspectFill
//            
//            scene.isUserInteractionEnabled = false
//            
//            scnView?.overlaySKScene = scene
//        }
        game.scnView = scnView
    }


}
