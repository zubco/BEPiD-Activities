//
//  FoodSelectionViewController.swift
//  Fitness
//
//  Created by Marcelo Reina on 15/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import UIKit

protocol FoodSelectionDelegate: NSObjectProtocol {
    func didSelectFoodItem(foodItem: FoodItem)
}

class FoodSelectionViewController: UIViewController {
    
    weak var delegate: FoodSelectionDelegate?

    @IBOutlet weak var tableView: UITableView!
    let foodList: [FoodItem] = FoodService.getFoodList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension FoodSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foodCell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
        
        let foodItem = foodList[indexPath.row]
        foodCell.textLabel?.text = foodItem.name
        foodCell.detailTextLabel?.text = "\(foodItem.kilocalories) Kcal"
        
        return foodCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }
    
}

extension FoodSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectionDelegate = delegate {
            let item = foodList[indexPath.row]
            selectionDelegate.didSelectFoodItem(foodItem: item)
            navigationController?.popViewController(animated: true)
        }
    }
}
