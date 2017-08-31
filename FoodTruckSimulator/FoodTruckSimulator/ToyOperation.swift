//
//  ToyOperation.swift
//  FoodTruckSimulator
//
//  Created by SERGIO J RAFAEL ORDINE on 17/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class ToyOperation: Operation {
    var toyImage:UIImage!
    
    var completionCallbackFunction:()->Void
    
    init(completion: @escaping ()->Void){
        completionCallbackFunction = completion
    }
    
    override func main() {
        toyImage = ToyServices.prepareToy()
        completionCallbackFunction()
    }
}
