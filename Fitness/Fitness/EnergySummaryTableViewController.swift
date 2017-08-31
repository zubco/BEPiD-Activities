//
//  EnergySummaryTableViewController.swift
//  Fitness
//
//  Created by Marcelo Reina on 15/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import UIKit

class EnergySummaryTableViewController: UITableViewController {

    @IBOutlet weak var totalEnergyText: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var burntCaloriesLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    fileprivate let calPerStep = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        var calories:Double?
        var totalSteps:Double?
        var caloriesBurnt:Double?
        
        EnergyConsumptionService.getTotalEnergyConsumedToday { (total) in
            if let total = total {
                calories = total
                self.totalEnergyText.text = "\(calories!) Kcal"
            } else {
                calories = 0
                self.totalEnergyText.text = "\(calories!) Kcal"
            }
        }
        
        EnergyConsumptionService.getSteps {  (total) in
            if let steps = total{
                totalSteps = steps
                self.stepsLabel.text = "\(totalSteps!) steps"
            } else {
                totalSteps = 0
                self.stepsLabel.text = "\(totalSteps!) steps"
            }
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        
        EnergyConsumptionService.getCaloriesBurnt(completion: { (total) in
            if let cb = total{
                caloriesBurnt = cb
                self.burntCaloriesLabel.text = "\(Double(caloriesBurnt!/1000).rounded()) Kcal"
            }else{
                caloriesBurnt = 0
                self.burntCaloriesLabel.text = "\(Double(caloriesBurnt!/1000).rounded()) Kcal"
            }
            semaphore.signal()
        })
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        OperationQueue.main.addOperation {
            self.balanceLabel.text = "\(calories! - Double(caloriesBurnt!/1000).rounded()) Kcal"
        }
    }
}
