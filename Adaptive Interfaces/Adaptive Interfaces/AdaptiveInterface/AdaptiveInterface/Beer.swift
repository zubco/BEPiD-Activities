//
//  Beer.swift
//  AdaptiveInterface
//
//  Created by SERGIO J RAFAEL ORDINE on 15/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation

enum BeerType {
    
    case pilsner
    case weissbier
    case redAle
    case stout
    
}

struct Beer {
    
    var name: String
    var imageName: String
    var description: String
    var type: BeerType
    
}
