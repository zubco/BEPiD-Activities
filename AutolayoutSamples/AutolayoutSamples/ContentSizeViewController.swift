//
//  ContenSizeViewController.swift
//  AutolayoutSamples
//
//  Created by SERGIO J RAFAEL ORDINE on 21/03/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class ContentSizeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet weak var contentHugging: UISlider!
    @IBOutlet weak var contentCompression: UISlider!
    
    @IBOutlet weak var leftImage: UIImageView!
    
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    

    
     // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //Set slider values
        //Slider size
        sizeSlider.minimumValue = -Float(self.view.frame.width)
        sizeSlider.maximumValue = 0
        if (imageWidth != nil) {
            sizeSlider.value = Float(imageWidth.constant)
        }
        
//       Set Content Hugging Slider
        contentHugging.minimumValue = 0
        contentHugging.maximumValue = 1000
        contentHugging.value = leftImage.contentHuggingPriority(for: .horizontal)
        
//        Set Compression Resistance Slider
        contentCompression.minimumValue = 0
        contentCompression.maximumValue = 1000
        contentCompression.value = leftImage.contentCompressionResistancePriority(for: .horizontal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Target-Actions
 
    @IBAction func sizeChanged(_ sender: UISlider) {
        
        let value = sender.value
        
        if (imageWidth != nil) {
            imageWidth.constant = CGFloat(value)
        }
        
    }
    
    @IBAction func contentHuggingChanged(_ sender: UISlider) {
        let value = sender.value
        
        leftImage.setContentHuggingPriority(value, for: .horizontal)
        leftImage.setContentHuggingPriority(value, for: .vertical)
       
        
    }
    
    @IBAction func contentCompressionChanged(_ sender: UISlider) {
        let value = sender.value
        
        leftImage.setContentCompressionResistancePriority(value, for: .horizontal)
        leftImage.setContentCompressionResistancePriority(value, for: .vertical)
       
    }
    



}
