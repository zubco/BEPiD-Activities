//
//  GoodViewController.swift
//  Protocol and Delegate Sample
//
//  Created by Gustavo Lima on 15/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class GoodViewController: UIViewController, GoodViewDelegate {

    @IBOutlet weak var goodView: GoodView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goodView.delegate = self
        
        goodView.showInformation()
    }


    func information() -> String
    {
        return "Good View 👍"
    }


}

