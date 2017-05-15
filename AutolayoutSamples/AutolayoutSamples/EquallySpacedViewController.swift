//
//  EquallySpacedViewController.swift
//  AutolayoutSamples
//
//  Created by SERGIO J RAFAEL ORDINE on 05/04/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class EquallySpacedViewController: UIViewController {

    
    @IBOutlet weak var bottomLeftView: UIView!
    
    @IBOutlet weak var bottomRightView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leadingGuide = UILayoutGuide()
        let centerGuide = UILayoutGuide()
        let rightGuide = UILayoutGuide()
        
        
        self.view.addLayoutGuide(leadingGuide)
        self.view.addLayoutGuide(centerGuide)
        self.view.addLayoutGuide(rightGuide)
        
        let margin = self.view.layoutMarginsGuide
        
        margin.leadingAnchor.constraint(equalTo: leadingGuide.leadingAnchor).isActive = true
        
        leadingGuide.trailingAnchor.constraint(equalTo: bottomLeftView.leadingAnchor).isActive = true
        centerGuide.leadingAnchor.constraint(equalTo: bottomLeftView.trailingAnchor).isActive = true
        centerGuide.trailingAnchor.constraint(equalTo: bottomRightView.leadingAnchor).isActive = true
        
        rightGuide.leadingAnchor.constraint(equalTo: bottomRightView.trailingAnchor).isActive = true
        rightGuide.trailingAnchor.constraint(equalTo: margin.trailingAnchor).isActive = true
        
        leadingGuide.widthAnchor.constraint(equalTo: centerGuide.widthAnchor).isActive = true
        centerGuide.widthAnchor.constraint(equalTo: rightGuide.widthAnchor).isActive = true
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
