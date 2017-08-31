//
//  ViewController.swift
//  SizeClasses
//
//  Created by SERGIO J RAFAEL ORDINE on 15/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var deviceImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        print("Change from \(previousTraitCollection) to \(traitCollection)")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if(self.traitCollection.userInterfaceIdiom == .pad){
            if(size.width>size.height){
                deviceImage.image = UIImage(named: "Device-landscape")
            }
            else{
                deviceImage.image = UIImage(named: "Device")
            }
        }
    }


}

