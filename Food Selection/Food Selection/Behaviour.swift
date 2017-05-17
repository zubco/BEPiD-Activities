//
//  Behaviour.swift
//  Food Selection
//
//  Created by Rafael Tomaz Prado on 22/03/17.
//  Copyright © 2017 Rafael Tomaz Prado. All rights reserved.
//

import UIKit

public protocol BehaviourProtocol:NSObjectProtocol{
    
}

class FoodOptions{
    var icon:String
    var name:String
    var price:Float
    
    init(_ icon: String, _ name: String, _ price: Float){
        self.icon = icon
        self.name = name
        self.price = price
    }
}

public class Behaviour: NSObject {
    
    var choiceArray:[FoodOptions]// = [FoodOptions]()
    var totalPrice = Float()
    
    public override init(){
        self.choiceArray = [FoodOptions]()
        super.init()
    }
    
    public weak var delegate:BehaviourProtocol?
    
    func chooseOption(_ opt: String){
        switch opt{
        case "🍔":
            choiceArray.append(FoodOptions(opt,"Hamburger",2.0))
            totalPrice += 2.0
        case "🍦":
            choiceArray.append(FoodOptions(opt,"Ice Cream",0.5))
            totalPrice += 0.5
        case "🍕":
            choiceArray.append(FoodOptions(opt,"Pizza",1.0))
            totalPrice += 1.0
        case "🍜":
            choiceArray.append(FoodOptions(opt,"Noodles",5.0))
            totalPrice += 5.0
        case "🍗":
            choiceArray.append(FoodOptions(opt,"Chicken",4.5))
            totalPrice += 4.5
        default:
            print("ERROR")
        }
    }
}
