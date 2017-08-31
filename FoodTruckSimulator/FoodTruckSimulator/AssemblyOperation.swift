//
//  AssemblyOperation.swift
//  FoodTruckSimulator
//
//  Created by SERGIO J RAFAEL ORDINE on 17/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class AssemblyOperation: Operation {
    
    var completionCallbackFunction:(Order!)->Void
    
    init(_ kitchen: KitchenOperation, _ toy: ToyOperation, completion: @escaping (Order!) -> Void) {
        completionCallbackFunction = completion
        super.init()
        self.addDependency(kitchen)
        self.addDependency(toy)
    }

    override func main() {
        //Relavant info
        var originalOrder: Order!
        var toyImage:UIImage!
        //Get info from previous operation
        for operation in self.dependencies {
            let kitchenOp = operation as? KitchenOperation
            if let kitchen = kitchenOp {
                originalOrder = kitchen.order
            }
            let toyOp = operation as? ToyOperation
            if let toy = toyOp {
                toyImage = toy.toyImage
            }
        }
        //Assemble final order
        let order = ToyServices.assembleToy(originalOrder, toyImage: toyImage)
        self.completionCallbackFunction(order)
    }
}
