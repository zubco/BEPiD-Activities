//
//  OpenAQCitiesServices.swift
//  AirMonitor
//
//  Created by Rafael Tomaz Prado on 28/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation

import UIKit

class OpenAQCitiesServices: CitiesServices {
    
    let cityURL = "https://api.openaq.org/v1/cities?country="
    
    func retrieveCities(for countryCode: String, completion:@escaping ([City]?) -> Void) {
        
        guard let url = URL(string: "\(cityURL)\(countryCode)") else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if (error == nil && data != nil) {
                do {
                    let cityJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let cities = self.parseCities(cityJSON)
                    completion(cities)
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    //MARK: Countries JSON parsing methods
    
    
    /// Parse the city list
    ///
    /// - Parameter json: JSON fragment containgin the cities list
    /// - Returns: List of countries parsed from JSON
    func parseCities(_ json:Any) -> [City]? {
        
        var cities = [City]()
        
        if let rootElement = json as? NSDictionary {
            if let results = rootElement["results"] as? NSArray {
                for cityData in results {
                    if let city = parseCity(cityData) {
                        cities.append(city)
                    }
                }
            }
        }
        
        return cities
        
    }
    
    
    /// Parse a city data from JSON
    ///
    /// - Parameter json: JSOn fragment containing the city definition
    /// - Returns: A country parsed from given JSON, if valid, nil otherwise
    func parseCity(_ json: Any) -> City? {
        
        if let cityData = json as? NSDictionary {
            
            if let name = cityData["city"] as? String {
                return City(name: name)
            }
            
        }
        
        return nil
        
    }
    
    
}
