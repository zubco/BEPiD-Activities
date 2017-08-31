//
//  ViewController.swift
//  FoodTruckSimulator
//
//  Created by SERGIO J RAFAEL ORDINE on 17/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class FoodTruckViewController: UIViewController {
    
    //MARK: - Attributes
    var orderList:[Order] = [Order]()
    var ticketNumber:Int = 0
    
    var kitchenOperationCounter = 0
    var toyOperationCounter = 0
    var assembleOperationCounter = 0
    
    //MARK: - Queues
    let kitchenQueue = OperationQueue()
    let mainQueue = OperationQueue.main
    let toyQueue = OperationQueue()
    
    //:MARK: - Outlets
    
    @IBOutlet weak var kitchenCounterLabel: UILabel!
    @IBOutlet weak var toyCounterLabel: UILabel!
    @IBOutlet weak var assembleCounterLabel: UILabel!
    
    @IBOutlet weak var kitchenActivity: UIActivityIndicatorView!
    @IBOutlet weak var toyActivity: UIActivityIndicatorView!
    @IBOutlet weak var assembleActivity: UIActivityIndicatorView!
    
    
    
    
    @IBOutlet weak var orderCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Actions
    
    @IBAction func orderSandwich(_ sender: UIButton) {
        let type = SandwichType(rawValue: sender.tag)
        
        if let sandwichType = type {
            
            //Increment Counters
            kitchenOperationCounter += 1
            toyOperationCounter += 1
            assembleOperationCounter += 1
            self.updateOperationsOnUI()
        
            let prepareOrderOperation = KitchenOperation(type: sandwichType, number: ticketNumber) { [unowned self] in
                self.kitchenOperationCounter -= 1
                self.mainQueue.addOperation {
                    self.updateOperationsOnUI()
                }
            }
            
            let toyOperation = ToyOperation() { [unowned self] in
                self.toyOperationCounter -= 1
                self.mainQueue.addOperation {
                    self.updateOperationsOnUI()
                }
            }
            
            let assemblyOperation = AssemblyOperation(prepareOrderOperation,toyOperation) { [unowned self]  (order) in
                self.assembleOperationCounter -= 1
                self.orderList.insert(order, at: 0)
                self.mainQueue.addOperation { [unowned self] in
                    self.updateOperationsOnUI()
                    self.orderCollection.reloadData()
                }
            }
            
            kitchenQueue.addOperation(prepareOrderOperation)
            toyQueue.addOperation(toyOperation)
            toyQueue.addOperation(assemblyOperation)
        }
    }
    
    // MARK: - Auxiliary Methods
    
    ///
    /// Update the operation counters and activity indicators on the UI
    ///
    func updateOperationsOnUI() {
        self.updateLabels()
        self.updateIndicators()
    }
    
    /// Update counter labels
    func updateLabels() {
        kitchenCounterLabel.text = "\(kitchenOperationCounter)"
        toyCounterLabel.text = "\(toyOperationCounter)"
        assembleCounterLabel.text = "\(assembleOperationCounter)"
    }
    
    /// Update activity indicators status and animation
    func updateIndicators() {
        checkIndicator(kitchenActivity, counter: kitchenOperationCounter)
        checkIndicator(toyActivity, counter: toyOperationCounter)
        checkIndicator(assembleActivity, counter: assembleOperationCounter)
    }
    
    
    ///Check a given counter and update an activity indicator accordingly.
    /// if the counter is set to 0 the activity indicator is hidden
    ///
    ///:param: activityIndicator The activity indicator which will be updated.
    ///:param: counter The counter to be used
    func checkIndicator(_ activityIndicator: UIActivityIndicatorView ,counter:Int) {
        if (counter == 0) {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }

}



// MARK: - Implements the Collection View (Delivered Orders) data source
extension FoodTruckViewController: UICollectionViewDataSource {
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sandwichCell", for: indexPath) as! SandwichCell
        let order = orderList[indexPath.row]
        
        cell.sandwichImage.image = order.sandwichImage
        cell.ticketNumber.text = "\(order.ticketNumber)"
        
        return cell
        
    }
    
}







