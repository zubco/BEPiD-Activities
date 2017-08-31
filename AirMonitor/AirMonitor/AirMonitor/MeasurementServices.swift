//
//  File.swift
//  AirQuality
//
//  Created by Sergio Ordine on 8/22/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation

protocol MeasurementServices {
    
   func retrieveMeasures(location:String, completion:@escaping ([Measure]?) -> Void)
    
}
