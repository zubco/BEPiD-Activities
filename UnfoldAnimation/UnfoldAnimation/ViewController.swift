//
//  ViewController.swift
//  UnfoldAnimation
//
//  Created by Rafael Tomaz Prado on 08/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var redView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unfoldTapped(_ sender: UIButton?) {
        let initialFrame = redView.frame
        let finalFrame = self.view.frame
        
        let greenView = UIView(frame: initialFrame)
        greenView.backgroundColor = .green
        greenView.clipsToBounds = true
        self.view.addSubview(greenView)
        self.view.bringSubview(toFront: greenView)
        
        //Unfold the view
        
        
    }
}

