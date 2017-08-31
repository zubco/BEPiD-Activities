//
//  PursueComponent.swift
//  GamaplaykitSenekit
//
//  Created by Gustavo Lima on 24/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import GameplayKit
import SceneKit

class PursueComponent: GKComponent {
    
    var target: SCNNode
    
    let movePointsPerSec: CGFloat = 1
    
    var velocity = CGPoint.zero
    
    /// A convenience property for the entity's geometry component.
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    init(target: SCNNode) {
        
        self.target = target
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Methods
    
    override func update(deltaTime dt: TimeInterval) {

        
        if let geometry = geometryComponent
        {
            let node = geometry.geometryNode
            
            let position = CGPoint(x: CGFloat(node.position.x),
                                   y: CGFloat(node.position.z))
            
            let targetPosition = CGPoint(x: CGFloat(target.presentation.position.x),
                                         y: CGFloat(target.presentation.position.z))
            
            
            let offset = CGPoint(x: targetPosition.x - position.x,
                                 y: targetPosition.y - position.y)

            let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))

            let direction = CGPoint(x: offset.x / CGFloat(length),
                                    y: offset.y / CGFloat(length))

            velocity = CGPoint(x: direction.x * movePointsPerSec,
                               y: direction.y * movePointsPerSec)
            
            node.position = SCNVector3(x: node.position.x + Float(velocity.x),
                                       y: node.position.y,
                                       z: node.position.z + Float(velocity.y))
            
            let angle = Float(atan2(Double(direction.y), Double(direction.x)))
          
            var amountToRotate:Float
            
            // 180 a -180
            if (angle < 0)
            {
                amountToRotate = 2 * .pi - angle
                
            } else {
                
                amountToRotate = -angle
            }
            
            node.rotation = SCNVector4(x: 0,
                                       y: 1,
                                       z: 0,
                                       w: amountToRotate)
        }
        
    }

}
