//
//  PriorityViewController.swift
//  AutolayoutSamples
//
//  Created by SERGIO J RAFAEL ORDINE on 01/03/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class PriorityViewController: UIViewController {
    
    @IBOutlet weak var sizeSlider: UISlider!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Use current slider value based on the width constraint (if defined)
        if let constraint = widthConstraint {
            sizeSlider.value = Float(constraint.constant)
        }
        
        //Set values for slider
        sizeSlider.minimumValue = 0
        sizeSlider.maximumValue = Float(self.view.bounds.width)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sizeChanged(_ sender: UISlider) {
        
        //Set the slider value as the width constraint constant (if defined)
        if let constraint = widthConstraint {
            constraint.constant = CGFloat(sender.value)
        }
       
    }

}
