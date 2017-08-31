//
//  EnergyConsumptionService.swift
//  Fitness
//
//  Created by Marcelo Reina on 15/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation

class EnergyConsumptionService {
    
    class func getTotalEnergyConsumedToday(completion: @escaping (Double?) -> ()) {
        let today = Date()
        HealthKitManager.shared.getTotalEnergyConsumedOn(specificDate: today) { (total) in
            DispatchQueue.main.async {
                completion(total)
            }
        }
    }
    
    class func getSteps(completion: @escaping(Double?) -> ()){
        let today = Date()
        HealthKitManager.shared.getTotalStepsWalked(specificDate: today){
            (total) in
            DispatchQueue.main.async{
                completion(total)
            }
        }
    }
    
    class func getCaloriesBurnt(completion: @escaping(Double?)->()){
        let today = Date()
        
        var weight:Double?
        var distance:Double?
        var time:Double?

        let dataQueue = OperationQueue()
        dataQueue.maxConcurrentOperationCount = 1
        
       
        // Get weight operation
        dataQueue.addOperation {
            
            let semaphore = DispatchSemaphore(value: 0)
           
            HealthKitManager.shared.getLastWeightData{  (value, unit) in
//                 print("getLastWeightData \(String(describing: value))")
                if let wei = value{
                    weight = wei
                }
                
                semaphore.signal()
            }
            
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        }
        
        // Get exercise time
        dataQueue.addOperation {
            
            let semaphore = DispatchSemaphore(value: 0)
            
            HealthKitManager.shared.getExerciseTime(specificDate: today, completion: { (hours) in
//                print("ExerciseTime \(String(describing: hours))")
                if let t = hours{
                    time = t
                }
                
                 semaphore.signal()
            })
            
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        }
        
        // Get distance walked operation
        dataQueue.addOperation {
            
            let semaphore = DispatchSemaphore(value: 0)
            
            HealthKitManager.shared.getDistanceWalked(specificDate: today, completion: { (dist) in
//                print("DistanceWalked \(String(describing: dist))")
                if let dist = dist{
                    distance = dist
                }
                
                semaphore.signal()
            })
            
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        }
        
        dataQueue.addOperation {
            
//            print("last operaation")
            if (time == nil){
                time = 24
            }
            
            let speed = (distance!/1000)/time!
            
            let caloriesBurnt = (0.0215 * pow(speed, 3.0) - 0.1765 * pow(speed, 2.0) + 0.8710 * speed + 1.4577) * weight! * time!
            
            completion(caloriesBurnt)
        }

    }
    
}
