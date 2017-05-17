//
//  AppDelegate.swift
//  BadCode
//
//  Created by Marcelo Reina on 24/02/17.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let viewController = UIViewController()
    var availableItemsView: UIView!
    var itemsToBePurchasedView: UIScrollView!
    var totalLabel: UILabel!
    var selectedItems = [UIView]()
    var selectedPrices = [Double]()
    var removeAllButton: UIButton!
    var itemSymbols = ["🍔", "🍦", "🍕", "🍜", "🍗"]
    var itemNames = ["hamburguer", "ice cream", "pizza", "noodles", "chicken"]
    var itemPrices = [2.0, 0.5, 1.0, 5.0, 4.5]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        createViewController()
        
        window?.makeKeyAndVisible()
        return true
    }
    
    func createViewController() {
        viewController.view.backgroundColor = UIColor.white
        window?.rootViewController = viewController
        
        var yOffset = 0
        
        availableItemsView = UIView(frame: CGRect(x: 0, y: yOffset, width: Int(viewController.view.bounds.width), height: 10+Int(viewController.view.bounds.height/CGFloat(itemNames.count))))
        availableItemsView.backgroundColor = UIColor.groupTableViewBackground
        viewController.view.addSubview(availableItemsView)
        
        yOffset = Int(availableItemsView.bounds.size.height)
        
        let availableItemsTitle = UILabel(frame: CGRect(x: 10, y: 10, width: Int(availableItemsView.bounds.width - 20), height: Int(availableItemsView.bounds.height)/itemNames.count))
        availableItemsTitle.font = UIFont(name: "Helvetica", size: 20)
        availableItemsTitle.textColor = UIColor.black
        availableItemsTitle.textAlignment = .left
        availableItemsTitle.text = "Choose your meal:"
        availableItemsView.addSubview(availableItemsTitle)
        
        let itemViewSize = CGSize(width: Int(availableItemsView.bounds.width-5)/itemNames.count, height: Int(availableItemsView.bounds.height) - Int(availableItemsTitle.bounds.height))
        
        
        for index in 0...itemNames.count-1 {
            let currentItem = UIButton(frame: CGRect(x: 5+(Int(itemViewSize.width)*index), y: 5 + Int(availableItemsTitle.bounds.height), width: Int(itemViewSize.width-5), height: Int(itemViewSize.height-10)))
            currentItem.setTitle("\(itemSymbols[index])", for: .normal)
            currentItem.titleLabel?.font = UIFont(name: "Helvetica", size: 50)
            currentItem.titleLabel?.textAlignment = .center
            currentItem.titleLabel?.textColor = UIColor.black
            currentItem.backgroundColor = UIColor.white
            currentItem.layer.cornerRadius = 2.0
            currentItem.layer.shadowOffset = CGSize(width: 1, height: 1)
            currentItem.layer.shadowColor = UIColor.black.cgColor
            currentItem.layer.shadowOpacity = 0.1
            currentItem.tag = index
            
            currentItem.addTarget(self, action: #selector(AppDelegate.addNewItem(sender:)), for: .touchUpInside)
            
            availableItemsView.addSubview(currentItem)
        }
        
        itemsToBePurchasedView = UIScrollView(frame: CGRect(x: 0, y: yOffset, width: Int(viewController.view.bounds.width), height: Int(viewController.view.bounds.size.height) - yOffset))
        itemsToBePurchasedView.backgroundColor = UIColor.groupTableViewBackground
        itemsToBePurchasedView.contentSize = itemsToBePurchasedView.bounds.size
        itemsToBePurchasedView.layer.cornerRadius = 2.0
        itemsToBePurchasedView.layer.borderWidth = 1.0
        itemsToBePurchasedView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        viewController.view.addSubview(itemsToBePurchasedView)
        
        removeAllButton = UIButton(frame: CGRect(x: 10, y: 1, width: 100, height: 25))
        removeAllButton.backgroundColor = UIColor.red
        removeAllButton.setTitle("remove all", for: .normal)
        removeAllButton.layer.cornerRadius = 2.0
        removeAllButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        removeAllButton.layer.shadowColor = UIColor.black.cgColor
        removeAllButton.layer.shadowOpacity = 0.1
        removeAllButton.addTarget(self, action: #selector(AppDelegate.removeAllAction(sender:)), for: .touchUpInside)
        itemsToBePurchasedView.addSubview(removeAllButton)
        
        
        totalLabel = UILabel(frame: CGRect(x: 10, y: 0, width: Int(itemsToBePurchasedView.bounds.width-20), height: 30))
        totalLabel.font = UIFont(name: "Helvetica", size: 20)
        totalLabel.textColor = UIColor.black
        totalLabel.textAlignment = .right
        itemsToBePurchasedView.addSubview(totalLabel)
        setTotalValue()
        
    }
    
    
    func addNewItem(sender: UIButton) {
        
        let originalSenderFrame = sender.frame
        sender.frame = CGRect(x: sender.frame.origin.x+2.5, y: sender.frame.origin.y+2.5, width: sender.frame.width-5, height: sender.frame.height-5)
        UIView.animate(withDuration: 0.2) {
            sender.frame = originalSenderFrame
        }
        
        var yOffset = Int(totalLabel.frame.origin.y + totalLabel.bounds.height)
        let viewHeight = 80
        
        if !selectedItems.isEmpty {
            yOffset += selectedItems.count * (viewHeight + 10)
        }
        
        let itemView = UIView(frame: CGRect(x: 10, y: yOffset, width: Int(itemsToBePurchasedView.bounds.width) - 20, height: viewHeight))
        itemView.backgroundColor = UIColor.white
        itemView.layer.cornerRadius = 2.0
        itemView.clipsToBounds = true
        
        let itemSymbolView = UILabel(frame: CGRect(x: 0, y: 0, width: viewHeight, height: viewHeight))
        itemSymbolView.font = UIFont(name: "Helvetica", size: 50)
        itemSymbolView.text = itemSymbols[sender.tag]
        itemSymbolView.textAlignment = .center
        itemView.addSubview(itemSymbolView)
        
        let itemNameView = UILabel(frame: CGRect(x: Int(itemSymbolView.bounds.width + 10), y: 0, width: Int(itemView.bounds.width - itemSymbolView.bounds.width + 10), height: viewHeight/2))
        itemNameView.font = UIFont(name: "Helvetica", size: 30)
        itemNameView.text = itemNames[sender.tag]
        itemNameView.textAlignment = .left
        itemView.addSubview(itemNameView)
        
        let itemPriceView = UILabel(frame: CGRect(x: Int(itemSymbolView.bounds.width + 10), y: viewHeight/2, width: Int(itemView.bounds.width - itemSymbolView.bounds.width + 10), height: viewHeight/2))
        itemPriceView.font = UIFont(name: "Helvetica", size: 20)
        itemPriceView.text = "$\(itemPrices[sender.tag])"
        itemPriceView.textAlignment = .left
        itemPriceView.textColor = UIColor.gray
        itemView.addSubview(itemPriceView)
        
        selectedItems.append(itemView)
        selectedPrices.append(itemPrices[sender.tag])
        itemsToBePurchasedView.addSubview(itemView)
        
        itemsToBePurchasedView.contentSize.height = selectedItems.last!.frame.origin.y + selectedItems.last!.bounds.height + 10
        
        itemView.frame.size.width = 0
        UIView.animate(withDuration: 0.5) { 
            itemView.frame.size.width = CGFloat(self.itemsToBePurchasedView.bounds.width - 20)
        }
        
        setTotalValue()
    }
    
    func setTotalValue() {
        if selectedItems.isEmpty {
            totalLabel.text = "0 items - Total: $0.0"
        } else {
            let total = selectedPrices.reduce(0,  { return $0 + $1 } )
            totalLabel.text = "\(selectedPrices.count) items - Total: $\(total)"
        }
        
        removeAllButton.isHidden = selectedItems.isEmpty
    }
    
    func removeAllAction(sender: UIButton) {
        selectedPrices.removeAll()
        for view in selectedItems {
            
            UIView.animate(withDuration: 0.5, animations: { 
                view.frame.size.width = 0
            }, completion: { (succeed) in
                view.removeFromSuperview()
            })
            
        }
        selectedItems.removeAll()
        setTotalValue()
    }
}
