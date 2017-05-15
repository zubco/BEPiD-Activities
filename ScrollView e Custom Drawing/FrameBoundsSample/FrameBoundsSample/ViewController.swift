//
//  ViewController.swift
//  FrameBoundsSample
//
//  Created by Gustavo Lima on 5/1/15.
//  Copyright (c) 2015 bepid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // view que vai girar
    @IBOutlet weak var grayView: UIView!
    
    // view para representar visualmente o frame da grayView
    @IBOutlet weak var viewFrame: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // a viewFrame está sobrepondo a grayview
        // aqui fazemos o fundo dela ficar transparente
        // e adicionamos uma borda na view para ela
        // representar visualmente o frame da grayview
        viewFrame.backgroundColor = UIColor.clear
        viewFrame.layer.borderColor = UIColor.black.cgColor
        viewFrame.layer.borderWidth = 1
    }

    @IBAction func sliderValueChanged(_ slider: UISlider) {
        
        // cada mudança de valor no slider
        // nós giramos a grayView o ângulo definido pelo slider 
        // que vai de 0 a 6.28(2π)
        grayView.transform = CGAffineTransform(rotationAngle: CGFloat(slider.value));
        
        // igualamos o frame da viewFrame com o da grayView
        // para ter a informação visual de como o frame muda
        viewFrame.frame = grayView.frame
    
    }
}

