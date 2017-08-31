//
//  KitchenOperation.swift
//  FoodTruckSimulator
//
//  Created by SERGIO J RAFAEL ORDINE on 17/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class KitchenOperation: Operation {
    var order:Order!
    var sandwichType:SandwichType
    var ticketNumber:Int
    
    var completionCallbackFuntion:()->Void
    
    init (type:SandwichType, number:Int, completion: @escaping ()->Void) {
        sandwichType = type
        ticketNumber = number
        completionCallbackFuntion = completion
    }
    
    override func main() {
        order = KitchenServices.prepareOrder(sandwichType,ticketNumber: ticketNumber)
        
        completionCallbackFuntion()
    }
}
