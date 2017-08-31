//
//  FoodService.swift
//  Fitness
//
//  Created by Marcelo Reina on 15/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation

class FoodService {
    
    class func getFoodList() -> [FoodItem] {
        return [
            FoodItem(name: "Água de coco verde", kilocalories: 62),
            FoodItem(name: "Café com açúcar", kilocalories: 33),
            FoodItem(name: "Café sem açúcar", kilocalories: 3),
            FoodItem(name: "Caldo de cana", kilocalories: 202),
            FoodItem(name: "Suco de abacaxi natural", kilocalories: 100),
            FoodItem(name: "Hamburger bovina", kilocalories: 116)
        ]
    }
    
    class func addFoodItem(_ foodItem: FoodItem,  completion: @escaping (Bool) -> ()) {
        HealthKitManager.shared.addFoodItem(foodItem: foodItem) { (succeed) in
            DispatchQueue.main.async {
                completion(succeed)
            }
        }
    }
    
    class func getFoodConsumedToday(completion: @escaping ([FoodItem]?) -> ()) {
        let today = Date()
        HealthKitManager.shared.getAllFoodItemsConsumedOn(specificDate: today) { foodItems in
            DispatchQueue.main.async {
                completion(foodItems)
            }
        }
    }
    
}
