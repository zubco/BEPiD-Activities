//
//  CitiesSevices.swift
//  AirMonitor
//
//  Created by Rafael Tomaz Prado on 28/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation

protocol CitiesServices{
    func retrieveCities(for countryCode: String, completion:@escaping ([City]?) -> Void)
}
