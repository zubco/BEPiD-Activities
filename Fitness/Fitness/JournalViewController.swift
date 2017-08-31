//
//  JournalViewController.swift
//  Fitness
//
//  Created by Marcelo Reina on 15/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var foodConsumed: [FoodItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadFoodConsumed()
    }
    
    func loadFoodConsumed() {
        FoodService.getFoodConsumedToday { (foodList) in
            self.foodConsumed = foodList
            self.tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddFoodItem" {
            let foodSelectionViewController = segue.destination as! FoodSelectionViewController
            foodSelectionViewController.delegate = self
        }
    }
}

extension JournalViewController: FoodSelectionDelegate {
    func didSelectFoodItem(foodItem: FoodItem) {
        FoodService.addFoodItem(foodItem) { (succeed) in
            self.loadFoodConsumed()
        }
    }
}

extension JournalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        if let foodList = foodConsumed {
            rows = foodList.count
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodJournalCell", for: indexPath)
        let foodItem = foodConsumed![indexPath.row]
        cell.textLabel!.text = foodItem.name
        cell.detailTextLabel!.text = "\(foodItem.kilocalories) Kcal"
        return cell
    }
}
