//
//  ResultController.swift
//  TextFieldsWorkbench
//
//  Created by Rafael Tomaz Prado on 04/04/17.
//  Copyright © 2017 Rafael Tomaz Prado. All rights reserved.
//

import UIKit

class ResultController: UIViewController, Protocol {

    var textFromField:String?
    var textFromView:String?
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstLabel.text = textFromField!
        self.secondLabel.text = textFromView!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
