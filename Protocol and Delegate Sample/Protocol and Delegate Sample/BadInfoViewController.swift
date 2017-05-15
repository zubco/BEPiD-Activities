//
//  BadViewController.swift
//  Protocol and Delegate Sample
//
//  Created by Gustavo Lima on 15/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class BadViewController: UIViewController {

    @IBOutlet weak var badView: BadView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        badView.badViewController = self
        
        badView.showInformation()
    }

    func information() -> String
    {
       return "Bad, Bad View 😱"
    }
}
