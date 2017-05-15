//
//  ViewController.swift
//  CustomView
//
//  Created by Marcelo Reina on 02/05/17.
//  Copyright © 2017 Marcelo Reina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ratingView: RatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.delegate = self
    }

}

//MARK: RatingViewDelegate implementation

extension ViewController: RatingViewDelegate {
    func willChangeRating(to newValue: Int) {
        print("will change => current value: \(ratingView.currentRating) new value: \(newValue)")
    }
    
    func didChangeRating(oldValue: Int) {
        print("did change => current value: \(ratingView.currentRating) old value: \(oldValue)")
    }
    
    func shouldClearRatingOnTap() -> Bool {
        return true
    }
    
    func shouldAnimateRatingChanges() -> Bool {
        return true
    }
}

