//
//  ImageScrollViewController.swift
//  ScrollViewSample
//
//  Created by Gustavo Lima on 5/2/15.
//  Copyright (c) 2015 bepid. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // seta o tamanho do conteúdo do scroll view com o tamanho maximo da imagem
        scrollView.contentSize = imageView.frame.size
        
        // limites minimo e maximo de zoom
        scrollView.minimumZoomScale = 0.3
        scrollView.maximumZoomScale = 1.0
        
        // zoom inicial
        scrollView.zoomScale = 0.3
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // retorna a view que receberá o zoom
        return imageView
    }
    

}
