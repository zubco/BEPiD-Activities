//
//  ProgramaticalConstraintsViewController.swift
//  AutolayoutSamples
//
//  Created by SERGIO J RAFAEL ORDINE on 03/04/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class ProgramaticalConstraintsViewController: UIViewController {
    
    var topView:UIView?
    var bottomView1:UIView?
    var bottomView2:UIView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        if let newView = topView{
            newView.backgroundColor = .blue
            self.view.addSubview(newView)
            
            let topConstraint = NSLayoutConstraint(item: newView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: newView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: newView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
            let heightConstraint = NSLayoutConstraint(item: newView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.2, constant: 0)
            
            self.view.addConstraints([topConstraint, leadingConstraint, trailingConstraint, heightConstraint])
            
            newView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bottomView1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        bottomView2 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        if let leftView = bottomView1, let rightView = bottomView2, let top = topView{
            self.view.addSubview(leftView)
            self.view.addSubview(rightView)
            
            leftView.backgroundColor = .red
            rightView.backgroundColor = .yellow
            
            leftView.translatesAutoresizingMaskIntoConstraints = false
            rightView.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[left(==right)]-[right]-|", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: ["left":leftView, "right":rightView]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[top]-[left(==top)]", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["left":leftView, "top":topView!]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[top]-[right(==top)]", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["right":rightView, "top":top]))

        }
    }
    


}
