//
//  Game.swift
//  SceneKitTraining
//
//  Created by Rafael Tomaz Prado on 12/06/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import SceneKit
import GameplayKit

class Game: NSObject, SCNSceneRendererDelegate, SCNPhysicsContactDelegate{
    
    weak var scnView:SCNView!
    
    private var cameraNode:SCNNode!
    private var cameraFollowNode:SCNNode!
    private var charNode:SCNNode!
    
    func setup(){
        setupNodes()
    }
    
    func setupNodes(){
        if let scene = self.scnView.scene{
            cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)!
            
            cameraFollowNode = scene.rootNode.childNode(withName: "FollowCamera",  recursively: true)!
            
            charNode = scene.rootNode.childNode(withName: "halths", recursively: true)
            
            scene.physicsWorld.contactDelegate = self
        }
    }
}
