//
//  ProfileServices.swift
//  Fitness
//
//  Created by Marcelo Reina on 11/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation

class ProfileService {
    
    class func getProfileAge() -> Int? {
        
        guard let dateOfBirth = HealthKitManager.shared.getProfileDayOfBirth() else {
            return nil
        }
        
        let now = Date()
        let ageComponents = NSCalendar.current.dateComponents([.year], from: dateOfBirth, to: now)
        return ageComponents.year
    }
    
    class func getProfileBiologicaSex() -> String? {
        return HealthKitManager.shared.getProfileBiologicalSexString()
    }

    class func getProfileHeight(completion: @escaping (Double?, String?) -> ()) {
        
        HealthKitManager.shared.getLastHeightData { (value, unit) in
            DispatchQueue.main.async {
                completion(value, unit)
            }
        }
    }
    
    class func getProfileWeight(completion: @escaping (_ value: Double?, _ unit: String?) -> ()) {
        
        HealthKitManager.shared.getLastWeightData { (value, unit) in
            DispatchQueue.main.async {
                completion(value, unit)
            }
        }
    }
}
