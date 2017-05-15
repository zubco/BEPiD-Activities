//
//  EndGameViewController.swift
//  WhereIsWallien
//
//  Created by Rafael Tomaz Prado on 10/05/17.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hides back button, so the only option is to return to the main menu
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func returnPressed(_ sender: Any) {
        // Returns to root view controller when touched
        self.navigationController?.popToRootViewController(animated: true)
    }
}
