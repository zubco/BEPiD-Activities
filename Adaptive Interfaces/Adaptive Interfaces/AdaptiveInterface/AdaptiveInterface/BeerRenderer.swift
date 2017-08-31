//
//  BeerRenderer.swift
//  AdaptiveInterface
//
//  Created by SERGIO J RAFAEL ORDINE on 15/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class BeerRenderer {
    
    static func imageForBeerType(_ beerType:BeerType)->UIImage!
    {
        var image:UIImage! = nil
        
        switch beerType {
        case .pilsner:
            image = UIImage(named:"pilsner")
        case .weissbier:
            image = UIImage(named:"weiss")
        case .redAle:
            image = UIImage(named:"red ale")
        case .stout:
            image = UIImage(named:"stout")
        }
        
        return image
    }
    
    
    static func beerTypes()->[(name:String,image:UIImage)] {
        var beerTypes:[(name:String,image:UIImage)] = []
        
        beerTypes += [(name:"Pilsner",image:imageForBeerType(.pilsner)!)]
        beerTypes += [(name:"Weissbier",image:imageForBeerType(.weissbier)!)]
        beerTypes += [(name:"Red Ale (IPA)",image:imageForBeerType(.redAle)!)]
        beerTypes += [(name:"Stout",image:imageForBeerType(.stout)!)]
        
        return beerTypes
    }

}
