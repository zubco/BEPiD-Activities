//
//  OpenAQMeasureServices.swift
//  AirQuality
//
//  Created by Sergio Ordine on 8/22/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class OpenAQMeasureServices: MeasurementServices {
    
    let measuresURL = "https://api.openaq.org/v1/measurements?location="
    var dateFormatter:DateFormatter!
    
    init() {
        
        //Initialize the data formatter (Local time)
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
    }
    
    func retrieveMeasures(location:String, completion:@escaping ([Measure]?) -> Void) {
        
        let fullURL = "\(measuresURL)\(location.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        
        //Retrieve locations from city
        guard let url = URL(string: fullURL) else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
           let measures = self.processMeasures(data, response, error)
                    
            completion(measures)
            
        }
        
        task.resume()
    }
    
    //MARK: Auxiliar functions
    
    
    func processMeasures(_ data :Data?,_ response: URLResponse?,_ error: Error?)->[Measure]?  {
        
        var measureList:[Measure]? = nil
        
        if (error == nil && data != nil) {
            do {
                let measuresJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                measureList = parseMeasures(measuresJSON)
            } catch {
                //Error - Keep list as nil
            }
        }
        
        return measureList
        
    }
    
    
    
    //MARK: - Measure parsing methods
    
    
    /// Parse a list of measurement events
    ///
    /// - Parameter json: JSON fragment containgin the list of measurement events
    /// - Returns: List of air quality measurement events
    func parseMeasures(_ json:Any) -> [Measure]? {
        
        var measures = [Measure]()
        
        if let rootElement = json as? NSDictionary {
            if let results = rootElement["results"] as? NSArray {
                for measureData in results {
                    if let measure = parseMeasure(measureData) {
                        measures.append(measure)
                    }
                }
            }
        }
        
        return measures
    }
    
    
    /// Parse one measurement event from JSON
    ///
    /// - Parameter json: JSON fragment representing an air quality measurement
    /// - Returns: An Air Quality measurement, nil if information is erred or unavailable
    func parseMeasure(_ json:Any) -> Measure? {
        
        if let measureData = json as? NSDictionary {
            
            if let date = measureData["date"] as? NSDictionary,
                let measureDate = date["local"] as? String,
                let parameterCode = measureData["parameter"] as? String,
                let parameterType = MeasureType(rawValue:parameterCode),
                let value = measureData["value"] as? Double,
                let unit = measureData["unit"] as? String
            {
                if let formattedDate = dateFormatter.date(from: measureDate) {
                    return Measure(date: formattedDate, type: parameterType, value: value, unit: unit)
                }
            }
        }
        
        
        return nil
    }
    


}
