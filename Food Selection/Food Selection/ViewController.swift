//
//  ViewController.swift
//  Food Selection
//
//  Created by Rafael Tomaz Prado on 22/03/17.
//  Copyright © 2017 Rafael Tomaz Prado. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BehaviourProtocol, UITableViewDataSource{
    
    fileprivate var behaviour = Behaviour()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var removeAllButton: UIButton!
    @IBOutlet weak var hamburgerButton: UIButton!
    @IBOutlet weak var iceCreamButton: UIButton!
    @IBOutlet weak var pizzaButton: UIButton!
    @IBOutlet weak var noodlesButton: UIButton!
    @IBOutlet weak var chickenButton: UIButton!
    private let radius = CGFloat(3.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.behaviour.delegate = self
        removeAllButton.isHidden = true
        removeAllButton.layer.cornerRadius = radius
        hamburgerButton.layer.cornerRadius = radius
        iceCreamButton.layer.cornerRadius = radius
        pizzaButton.layer.cornerRadius = radius
        noodlesButton.layer.cornerRadius = radius
        chickenButton.layer.cornerRadius = radius
    }
    
    @IBAction func buttonIsPressed(_ sender: UIButton){
        if let option = sender.titleLabel?.text{
            self.behaviour.chooseOption(option)
        }
        removeAllButton.isHidden = false
        totalLabel.text = ("\(behaviour.choiceArray.count) items - Total: $\(behaviour.totalPrice)")
        tableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return behaviour.choiceArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CellController
        cell.icon.text = behaviour.choiceArray[indexPath.row].icon
        cell.name.text = behaviour.choiceArray[indexPath.row].name
        cell.price.text = "$"+String(behaviour.choiceArray[indexPath.row].price)
        cell.layer.cornerRadius = radius
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete){
            let option = behaviour.choiceArray.remove(at: indexPath.row)
            behaviour.totalPrice -= option.price
            totalLabel.text = ("\(behaviour.choiceArray.count) items - Total: $\(behaviour.totalPrice)")
            if(behaviour.choiceArray.count == 0){
                removeAllButton.isHidden = true
            }
            tableView.reloadData()
        }
    }

    @IBAction func removeAllButton(_ sender: UIButton) {
        behaviour.choiceArray.removeAll()
        behaviour.totalPrice = 0.0
        totalLabel.text = ("\(behaviour.choiceArray.count) items - Total: $\(behaviour.totalPrice)")
        tableView.reloadData()
        removeAllButton.isHidden = true
    }
    
    
}

