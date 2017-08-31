//
//  KitchenServices.swift
//  FoodTruckSimulator
//
//  Created by SERGIO J RAFAEL ORDINE on 17/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class KitchenServices {
    
    
    static func prepareOrder(_ type:SandwichType, ticketNumber:Int) -> Order! {
        var order:Order!
        
        //Select image URL
        var imagePath:String!
        
        switch(type){
        case .cheeseBuger:
            imagePath =  "http://www.redrobinpa.com/wp-content/uploads/2011/02/120506_WhiskeyRiverBBQBurger_hr.jpg"
        case .mistoQuente:
            imagePath = "http://www.seriouseats.com/images/2013/10/269540-papillote-croque-monsieur-top.jpg"
        default:
            imagePath = nil
        }
        
        
        if (imagePath != nil) {
            let url = URL(string: imagePath)
            
            if let imageURL = url {
                //Convert data to image
                let data = try? Data(contentsOf: imageURL )
                //If conversion was ok, create the order
                if let imageData = data {
                    let baseImage = UIImage(data: imageData)
                    order = Order(ticketNumber: ticketNumber, sandwichImage: baseImage)
                }
            }
        }
        
        return order
    }

}
