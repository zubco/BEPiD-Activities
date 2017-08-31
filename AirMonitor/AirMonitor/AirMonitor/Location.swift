//
//  File.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation


struct Location {
    
    var name:String
    var measures:[MeasureType:Measure]?
    var collapsed:Bool
    
    init(name: String, measures: [MeasureType:Measure]? , collapsed: Bool = true){
        self.name = name
        self.measures = measures
        self.collapsed = collapsed
    }
}
