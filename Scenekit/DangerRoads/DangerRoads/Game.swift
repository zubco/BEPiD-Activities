//
//  Game.swift
//  DangerRoads
//
//  Created by Gustavo Lima on 25/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import SceneKit
import GameplayKit


struct PhysicsCategory {
    static let none     = 0     // 0
    static let player   = 0b1   // 1
    static let powerup  = 0b10  // 2
    static let money    = 0b100 // 4
    static let police   = 0b1000// 8
}

class Game: NSObject, SCNSceneRendererDelegate, SCNPhysicsContactDelegate{
    
    var lastUpdateTime: TimeInterval = 0
    
    // Camera
    var cameraNode: SCNNode!
    var cameraFollowNode: SCNNode!
    
    // Player
    private var vehicle: SCNPhysicsVehicle!
    private var vehicleNode: SCNNode!
    
    // Enemies
    private var policeNode: SCNNode!
    
    // steering factor
    var vehicleSteering: CGFloat = 0.0
    var engineForce: CGFloat = 400.0
    
    weak var scnView: SCNView!
    
    var enemies = [GKEntity]()
    
    let pursueComponentSystem =  GKComponentSystem(componentClass: PursueComponent.self)

    var money:Int = 0
    
    func setup()
    {
        setupNodes()
        setUpEntities()
        addComponentsToComponentSystems()
    }
    
    func setupNodes() {
        
        if let scene = scnView.scene
        {
            cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)!
            
            cameraFollowNode = scene.rootNode.childNode(withName: "FollowCamera", recursively: true)!
            
            // must be before the agent because this will be the agent goal
            vehicleNode = setupVehicle()
            
            scene.physicsWorld.contactDelegate = self
            
        }
    }

    func setUpEntities()
    {
        let policeEntity = GKEntity()
        policeNode = scnView.scene?.rootNode.childNode(withName: "police", recursively: false)

        let policeGeometryComponent = GeometryComponent(geometryNode: policeNode)
        policeEntity.addComponent(policeGeometryComponent)
        
        let pursueComponent = PursueComponent(target: vehicleNode)
        policeEntity.addComponent(pursueComponent)

        self.enemies.append(policeEntity)
     
    }
    
    func addComponentsToComponentSystems() {
        
        for enemy in enemies {
            pursueComponentSystem.addComponent(foundIn: enemy)
        }
    }
    
    private func setupVehicle() -> SCNNode {
        
        let chassisNode = scnView.scene?.rootNode.childNode(withName: "truckBody", recursively: true)
        
        //add wheels
        let wheel0Node = chassisNode!.childNode(withName: "wheelLocator_FL", recursively: true)!
        let wheel1Node = chassisNode!.childNode(withName: "wheelLocator_FR", recursively: true)!
        let wheel2Node = chassisNode!.childNode(withName: "wheelLocator_RL", recursively: true)!
        let wheel3Node = chassisNode!.childNode(withName: "wheelLocator_RR", recursively: true)!
        
        let wheel0 = SCNPhysicsVehicleWheel(node: wheel0Node)
        let wheel1 = SCNPhysicsVehicleWheel(node: wheel1Node)
        let wheel2 = SCNPhysicsVehicleWheel(node: wheel2Node)
        let wheel3 = SCNPhysicsVehicleWheel(node: wheel3Node)
        
        let (min, max) = wheel0Node.boundingBox
        let wheelHalfWidth = Float(0.9 * (max.x - min.x))
        
        wheel0.connectionPosition = SCNVector3FromFloat3(SCNVector3ToFloat3(wheel0Node.convertPosition(SCNVector3Zero, to: chassisNode)) + float3(wheelHalfWidth, 0, 0))
        wheel1.connectionPosition = SCNVector3FromFloat3(SCNVector3ToFloat3(wheel1Node.convertPosition(SCNVector3Zero, to: chassisNode)) - float3(wheelHalfWidth, 0, 0))
        wheel2.connectionPosition = SCNVector3FromFloat3(SCNVector3ToFloat3(wheel2Node.convertPosition(SCNVector3Zero, to: chassisNode)) + float3(wheelHalfWidth, 0, 0))
        wheel3.connectionPosition = SCNVector3FromFloat3(SCNVector3ToFloat3(wheel3Node.convertPosition(SCNVector3Zero, to: chassisNode)) - float3(wheelHalfWidth, 0, 0))
        
        // create the physics vehicle
        let vehicle = SCNPhysicsVehicle(chassisBody: chassisNode!.physicsBody!, wheels: [wheel0, wheel1, wheel2, wheel3])
        
        scnView.scene?.physicsWorld.addBehavior(vehicle)
        
        self.vehicle = vehicle
        
        return chassisNode!
    }
    

    
    func updatePositions() {
        
        let lerpX = (vehicleNode.presentation.position.x - cameraFollowNode.position.x) * 0.05
        let lerpZ = (vehicleNode.presentation.position.z - cameraFollowNode.position.z) * 0.05
        
        cameraFollowNode.position.x += lerpX
        cameraFollowNode.position.z += lerpZ
    }
    
    
    func renderer(_ aRenderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        
        //update the vehicle steering and acceleration
        
        vehicle.applyEngineForce(engineForce, forWheelAt: 2)
        vehicle.applyEngineForce(engineForce, forWheelAt: 3)
        
        vehicle.setSteeringAngle(vehicleSteering, forWheelAt: 0)
        vehicle.setSteeringAngle(vehicleSteering, forWheelAt: 1)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time:
        TimeInterval) {
        
        updatePositions()
        
    }

    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        // Calculate delta since last update and pass along to the agent system.
        if (lastUpdateTime == 0) {
            lastUpdateTime = time
        }
        
        let deltaTime = time - lastUpdateTime
        
        pursueComponentSystem.update(deltaTime: deltaTime)
        
        lastUpdateTime = time
        
    }

    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        var collisionNode: SCNNode!
        
        if contact.nodeA.physicsBody?.categoryBitMask == PhysicsCategory.player {
            collisionNode = contact.nodeB
        } else {
            collisionNode = contact.nodeA
        }
        
        collisionNode.isHidden = true
        
        let respawn = SCNAction.sequence([
            SCNAction.wait(duration: 30),
            SCNAction.run({ (node) in
                node.isHidden = false
            })
            ])
        
        collisionNode.runAction(respawn)
        
        if collisionNode.physicsBody?.categoryBitMask == PhysicsCategory.powerup{
            print("powerup box")
        }
        
        if collisionNode.physicsBody?.categoryBitMask == PhysicsCategory.money {
         
            addMoney()
        }
    }
    
    func addMoney()
    {
        if let hud = scnView?.overlaySKScene
        {
            let moneyLabel = hud.childNode(withName: "money") as! SKLabelNode
            
            self.money += 1
            
            moneyLabel.text = String(describing:self.money)
        }
    }
}
