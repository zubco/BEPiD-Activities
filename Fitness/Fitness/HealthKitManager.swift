//
//  HealthKitManager.swift
//  Fitness
//
//  Created by Marcelo Reina on 11/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation
import HealthKit


/// All healthkit specific content is managed by this class
class HealthKitManager {
    
    //MARK: Singleton Implementation
    
    /// shared instance to be used by the entire app
    static let shared: HealthKitManager = HealthKitManager()
    fileprivate init() {}
    
    /// link to the health database
    fileprivate let healthstore: HKHealthStore = HKHealthStore()
    
    // MARK: Public interface
    
    /// Description
    ///
    /// - Parameter completion: completion handler that has a Bool parameter indicating whether the process was completed successfully
    func requestUserPermission(completion: @escaping (Bool) -> ()) {
        
        // represents the success or failure of presenting and storing user
        // choices regarding the requirements.
        var completionResult = false
        
        // first of all, check for availability. Some devices don't have health
        // data, such as the iPad.
        if HKHealthStore.isHealthDataAvailable() {
            
            // request authorization for read/write specific data defined on
            // dataTypesToRead and dataTypesToWirte
            healthstore.requestAuthorization(toShare: dataTypesToWrite(), read: dataTypesToRead()) { (result, error) in
                
                if error == nil {
                    completionResult = result
                }
                
                completion(completionResult)
            }
        } else {
            completion(completionResult)
        }
    }
    
    /// Access the health store and retrieve the date of birth if it was previously set
    ///
    /// - Returns: the birth date or nil if it was not set
    func getProfileDayOfBirth() -> Date? {
        // using a try? because the function returs nil whether the date was not set
        guard let birthdayComponent = try? healthstore.dateOfBirthComponents() else {
            return nil
        }
        
        return birthdayComponent.date
    }
    
    
    /// Access the health store and retrieve the biological sex.
    ///
    /// - Returns: A string representing the biological sex
    func getProfileBiologicalSexString() -> String? {
        // using a try? because the function returs nil whether the biological sex was not set
        guard let biologicalSex = try? healthstore.biologicalSex() else {
            return nil
        }
        
        switch biologicalSex.biologicalSex {
        case .male:
            return "Masculino"
        case .female:
            return "Feminino"
        case .other:
            return "Outro"
        case .notSet:
            return "Não definido"
        }
    }
    
    
    /// Access the health store and retrieve the data from the last weight sample.
    ///
    /// - Parameter completion: completion handler that has a Double? representing the value of the sample and a String? representing the unit of the value. Both parameters will be nil if there was any problem during the process.
    func getLastWeightData(completion: @escaping (Double?, String?) -> ()) {
        getLastDataQuantitySample(for: .bodyMass) { (quantitySample) in
            
            if quantitySample != nil {
                // Usign a hard-coded unit for the example. Is there a way to get the unit specified by the user on the health app?
                let unitString = "kg"
                let value = quantitySample?.quantity.doubleValue(for: HKUnit(from: unitString))
                completion(value, unitString)
                
            } else {
                completion(nil, nil)
            }
        }
    }
    
    /// Access the health store and retrieve the data from the last height sample.
    ///
    /// - Parameter completion: completion handler that has a Double? representing the value of the sample and a String? representing the unit of the value. Both parameters will be nil if there was any problem during the process.
    func getLastHeightData(completion: @escaping (Double?, String?) -> ()) {
        getLastDataQuantitySample(for: .height) { (quantitySample) in
            
            if quantitySample != nil {
                // Usign a hard coded unit for the example. Is there a way to get the unit specified by the user on the health app?
                let unitString = "cm"
                let value = quantitySample?.quantity.doubleValue(for: HKUnit(from: unitString))
                completion(value, unitString)
                
            } else {
                completion(nil, nil)
            }
        }
    }
    
    
    /// Store a food item on health store
    ///
    /// - Parameters:
    ///   - foodItem: food item to be stored
    ///   - completion: completion handler indicating the result of the operation
    func addFoodItem(foodItem: FoodItem, completion: @escaping (Bool) -> ()) {
        
        // convert FoodItem to HKCorrelation to store at health store
        let foodCorrelation: HKCorrelation = foodCorrelationFromFoodItem(foodItem)
        
        // saves and call the completion handler
        healthstore.save(foodCorrelation) { (success, error) in
            if error == nil {
                completion(success)
            } else {
                completion(false)
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    
    /// Access the health store and retrieve all food item data from a specific date.
    ///
    /// - Parameters:
    ///   - specificDate: date of the desired data
    ///   - completion: completion handler that has a [FoodItem]? as parameter. If there are any entries on the specific date, it will be available as a FoodItem. The parameter will be nil if any problem occurs.
    func getAllFoodItemsConsumedOn(specificDate: Date, completion: @escaping ([FoodItem]?) -> () ) {
        
        // get start and end date based on specificDate
        let calendar: Calendar = Calendar.current
        let datecomponents: DateComponents = calendar.dateComponents([.year, .month, .day], from: specificDate)
        let startDate: Date = calendar.date(from: datecomponents)!
        let endDate: Date = calendar.date(byAdding: .day, value: 1, to: specificDate)!
        
        // create food correlation type to use on the query
        let foodType: HKCorrelationType = HKObjectType.correlationType(forIdentifier: .food)!
        // using a HKQuery to create the predicate with start and end dates
        let predicate: NSPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .init(rawValue: 0))
        // create the HKSampleQuery without limit
        let query: HKSampleQuery = HKSampleQuery(sampleType: foodType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (sampleQuery, samples, error) in
            if error == nil {
                var foodItems: [FoodItem] = [FoodItem]()
                
                if let correlations = samples as? [HKCorrelation]? {
                    for foodCorrelation in correlations! {
                        foodItems.append(self.foodItemFromFoodCorrelation(foodCorrelation))
                    }
                }
                
                completion(foodItems)
            } else {
                completion(nil)
                print("Error: \(error!.localizedDescription)")
            }
            
        }
        
        // execute the query (don't forget this step!!)
        healthstore.execute(query)
    }
    
    
    /// Access the health store and retrieve the sum of energy consumed on a specific date.
    ///
    /// - Parameters:
    ///   - specificDate: date of the desired data
    ///   - completion: completion handler that has a Double? as parameter. If there are any entries on the specific date, it will be calculated by HKStatisticsQuery. The parameter will be nil if any problem occurs.
    func getTotalEnergyConsumedOn(specificDate: Date, completion: @escaping (Double?) -> ()) {
        
        // get start and end date based on specificDate
        let calendar: Calendar = Calendar.current
        let datecomponents: DateComponents = calendar.dateComponents([.year, .month, .day], from: specificDate)
        let startDate: Date = calendar.date(from: datecomponents)!
        let endDate: Date = calendar.date(byAdding: .day, value: 1, to: specificDate)!
        
        // create the energy consumed quantity type
        let quantityType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
        // using a HKQuery to create the predicate with start and end dates
        let predicate: NSPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .init(rawValue: 0))
        
        // create the HKStatisticsQuery using .cumulativeSum to get the total energy consumed on the specificDate
        let statisticsQuery = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (quey, statistics, error) in
            if error == nil {
                if statistics != nil {
                    let quantity = statistics?.sumQuantity()
                    // Usign a hard-coded unit for the example. Is there a way to get the unit specified by the user on the health app?
                    let total = quantity?.doubleValue(for: HKUnit.kilocalorie())
                    completion(total)
                } else {
                    completion(0)
                }
            } else {
                completion(nil)
            }
        }
        healthstore.execute(statisticsQuery)
    }
    
    
    /// Access the health store and retrieve the number of steps walked on the specified date.
    ///
    /// - Parameters:
   ///    - specificDate: date of the desired date
    ///   - completion: completion handler that has a Double? as parameter. If there are any entries on the specific date, it will be calculated by HKStatisticsQuery. The parameter will be nil if any problem occurs.
    func getTotalStepsWalked(specificDate: Date, completion: @escaping (Double?)->()){
        
        // get start and end date based on specificDate
        let calendar: Calendar = Calendar.current
        let datecomponents: DateComponents = calendar.dateComponents([.year, .month, .day], from: specificDate)
        let startDate: Date = calendar.date(from: datecomponents)!
        let endDate: Date = calendar.date(byAdding: .day, value: 1, to: specificDate)!
        
        // create the stepsCount quantity type
        let quantityType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        // using a HKQuery to create the predicate with start and end dates
        let predicate: NSPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .init(rawValue: 0))
        
        let statisticQuery = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum, completionHandler: {(query, statistics, error) in
            if error == nil{
                if statistics != nil{
                    let count = statistics?.sumQuantity()
                    let total = count?.doubleValue(for: HKUnit.count())
                    completion(total)
                }else{
                    completion(nil)
                }
            }else{
                completion(nil)
            }
        })
        
        healthstore.execute(statisticQuery)
    }
    
    func getDistanceWalked(specificDate: Date, completion: @escaping (Double?)->()){
        // get start and end date based on specificDate
        let calendar: Calendar = Calendar.current
        let datecomponents: DateComponents = calendar.dateComponents([.year, .month, .day], from: specificDate)
        let startDate: Date = calendar.date(from: datecomponents)!
        let endDate: Date = calendar.date(byAdding: .day, value: 1, to: specificDate)!
        
        // create the stepsCount quantity type
        let quantityType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        // using a HKQuery to create the predicate with start and end dates
        let predicate: NSPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .init(rawValue: 0))
        
        
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum, completionHandler: { (query, statistics, error) in
            if error == nil{
                if statistics != nil{
                    let count = statistics?.sumQuantity()
                    let total = count?.doubleValue(for: HKUnit.meter())
                    completion(total)
                }else{
                    completion(nil)
                }
            }else{
                completion(nil)
            }
        })
        healthstore.execute(query)
    }
    
    func getExerciseTime(specificDate: Date, completion: @escaping (Double?)->()){
        // get start and end date based on specificDate
        let calendar: Calendar = Calendar.current
        let datecomponents: DateComponents = calendar.dateComponents([.year, .month, .day], from: specificDate)
        let startDate: Date = calendar.date(from: datecomponents)!
        let endDate: Date = calendar.date(byAdding: .day, value: 1, to: specificDate)!
        
        // create the stepsCount quantity type
        let quantityType:HKQuantityType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!
        // using a HKQuery to create the predicate with start and end dates
        let predicate: NSPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .init(rawValue: 0))
        
        
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum, completionHandler: { (query, statistics, error) in
            if error == nil{
                if statistics != nil{
                    let count = statistics?.sumQuantity()
                    let total = count?.doubleValue(for: HKUnit.hour())
                    completion(total)
                }else{
                    completion(nil)
                }
            }else{
                completion(nil)
            }
        })
        healthstore.execute(query)
    }
    
    
    //MARK: Private methods
    
    
    /// Access the health store and retrieve the last entry of a HKQuantitySample specified by quantityIdentifier
    ///
    /// - Parameters:
    ///   - quantityIdentifier: Identifier to specify the HKQuantitySample to be retrieved
    ///   - completion: completion handler that has a HKQuantitySample? as parameter. It will be nil if any problem occur
    fileprivate func getLastDataQuantitySample(for quantityIdentifier: HKQuantityTypeIdentifier, completion: @escaping (_ quantitySample: HKQuantitySample?) -> ()) {
        
        // create the quantity type based on the quantityIdentifier
        let quantityType: HKQuantityType? = HKQuantityType.quantityType(forIdentifier: quantityIdentifier)
        
        // this quantityType is necessary to create the query. If it was created, the query will not be performed.
        guard quantityType != nil else {
            completion(nil)
            return
        }
        
        // create a sort descriptor to order the results by the end date in ascending order.
        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        // create a HKSampleQuery with no predicate and limited by 1 to get only the last entry
        let query = HKSampleQuery(sampleType: quantityType!, predicate: nil, limit: 1, sortDescriptors: [timeSortDescriptor]) { (sampleQuery, results, error) in
            if error == nil {
                if results!.isEmpty {
                    completion(nil)
                } else {
                    let quantitySample: HKQuantitySample = results!.first as! HKQuantitySample
                    completion(quantitySample)
                }
            } else {
                print("Error: \(error!.localizedDescription)")
                completion(nil)
            }
        }
        
        // execute the query (don't forget this step!!)
        healthstore.execute(query)
    }
    
    /// Helper function to convert a HKCorrelation into a FoodItem
    ///
    /// - Parameter foodCorrelation: food correlation probably retrieved from health store
    /// - Returns: FoodItem representing the foodCorrelation
    fileprivate func foodItemFromFoodCorrelation(_ foodCorrelation: HKCorrelation) -> FoodItem {
        // get the name of the food accessing the correlation's metadata. Observe that HealthKit provides type identifiers to be used as keys of the dictionary
        let foodName = foodCorrelation.metadata![HKCorrelationTypeIdentifier.food.rawValue] as! String
        
        // create the energy consumed type
        let energyConsumedType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)
        // get the samples from the correlation
        let energyConsumedSamples = foodCorrelation.objects(for: energyConsumedType!)
        // in this case, we'll have just one sample
        let energyConsumedSample: HKQuantitySample = energyConsumedSamples.first! as! HKQuantitySample
        // get the HKQuantity from the sample
        let energyQuantityConsumed: HKQuantity = energyConsumedSample.quantity
        // get the calories value from HKQuantity
        let foodCalories: Double = energyQuantityConsumed.doubleValue(for: HKUnit.kilocalorie())
        
        // return a new FoodItem object
        return FoodItem(name: foodName, kilocalories: foodCalories)
    }
    
    /// Helper function to convert a FoodItem into a HKCorrelation
    ///
    /// - Parameter foodItem: food item to be converted to HKCorrelation, probably to be stored on health store
    /// - Returns: HKCorrelation representing the FoodItem
    fileprivate func foodCorrelationFromFoodItem(_ foodItem: FoodItem) -> HKCorrelation {
        
        
        let now: Date = Date()
        // create a HKQuantity based in the unit it will store
        let energyQuantityConsumed = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: foodItem.kilocalories)
        // create a HKQuantityType for energy consumed
        let energyConsumedType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)
        // create a HKQuantitySample that represents the type and quantity of the sample
        let energyConsumedSample = HKQuantitySample.init(type: energyConsumedType!, quantity: energyQuantityConsumed, start: now, end: now)
        
        // create a correlation type
        let foodType = HKObjectType.correlationType(forIdentifier: .food)
        
        // create the metadata usign HealthKit identifiers
        let foodCorrelationMetadata: [String: Any] = [HKCorrelationTypeIdentifier.food.rawValue: foodItem.name]
        
        // create the HKCorrelation and return it
        let foodCorrelation = HKCorrelation(type: foodType!, start: now, end: now, objects: [energyConsumedSample], metadata: foodCorrelationMetadata)
        return foodCorrelation
    }
    
    /// Set of HKSampleType that will need the permission for writing on health store
    ///
    /// - Returns: all HKSampleType that the app needs permission to write
    fileprivate func dataTypesToWrite() -> Set<HKSampleType> {
        let energyConsumedType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
        return [energyConsumedType!]
    }
    
    /// Set of HKSampleType that will need the permission for reading from health store
    ///
    /// - Returns: all HKSampleType that the app needs permission to read
    fileprivate func dataTypesToRead() -> Set<HKObjectType> {
        let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex)
        let dateOfBirthType = HKObjectType.characteristicType(forIdentifier: .dateOfBirth)
        let dietaryCalorieEnergyType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
        let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass)
        let heightType = HKObjectType.quantityType(forIdentifier: .height)
        let energyConsumedType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
        let stepsWalked = HKObjectType.quantityType(forIdentifier: .stepCount)
        let distanceWalked = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        let exerciseTime = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
        return [biologicalSex!, dateOfBirthType!, dietaryCalorieEnergyType!, bodyMassType!, heightType!, energyConsumedType!, stepsWalked!, distanceWalked!, exerciseTime!]
    }
    
}
