//
//  OpenAQLocationServices.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class OpenAQLocationServices: LocationServices {
    
    let locationsURL = "https://api.openaq.org/v1/locations?city="

    func retrieveLocations(for cityCode: String,completion:@escaping ([Location]?) -> Void) {
        
        //Retrieve locations from city
        guard let url = URL(string: "\(locationsURL)\(cityCode)") else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest) { [unowned self] (data, response, error) in
            
            if (error == nil && data != nil) {
                do {
                    let locationJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let locations = self.parseLocations(locationJSON) {
                        completion(locations)
                    }
                } catch {
                    completion(nil)
                }
            }else{
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    //MARK: - Location parsing methods
    
    func parseLocations(_ json:Any) -> [Location]? {
        
        var locations = [Location]()
        
        if let rootElement = json as? NSDictionary {
            if let results = rootElement["results"] as? NSArray {
                for locationData in results {
                    if let location = parseLocation(locationData) {
                        locations.append(location)
                    }
                }
            }
        }
        
        return locations
    }
    
    
    func parseLocation(_ json: Any) -> Location? {
        
        if let locationData = json as? NSDictionary {
            if let name = locationData["location"] as? String {
                let location = Location(name: name, measures: nil)
                return location
            }
        }
        return nil
    }
}
