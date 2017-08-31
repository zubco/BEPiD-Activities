//
//  BeerDetailViewController.swift
//  AdaptiveInterface
//
//  Created by SERGIO J RAFAEL ORDINE on 15/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class BeerDetailViewController: UIViewController {
    
    //MARK: - Attributes
    var selectedBeer = BeerManager.defaultBeer
    
    
    // MARK: - Outlets
    @IBOutlet weak var thumbnailImage: UIImageView?
    @IBOutlet weak var largeImage: UIImageView?
    @IBOutlet weak var beerIcon: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    // MARK: - View lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(BeerDetailViewController.beerTypes(_:)))
        beerIcon.addGestureRecognizer(tap)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Load Information for the current beer
        titleLabel.text = selectedBeer.name
        descriptionLabel.text = selectedBeer.description
        
        if let thumbnail = thumbnailImage {
            thumbnail.image = UIImage(named: selectedBeer.imageName)
        }
        
        if let largeImage = self.largeImage {
            largeImage.image = UIImage(named: selectedBeer.imageName)
        }
        
        beerIcon.image = BeerRenderer.imageForBeerType(selectedBeer.type)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let thumbnail = thumbnailImage {
            //Rounded Image
            thumbnail.layer.cornerRadius = thumbnail.bounds.size.width / 2.0
            thumbnail.clipsToBounds = true
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func beerTypes (_ tap:UITapGestureRecognizer) {
        performSegue(withIdentifier: "beerTypes", sender: self)
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

extension BeerDetailViewController: UIPopoverPresentationControllerDelegate{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.popoverPresentationController!.delegate = self
        
        segue.destination.preferredContentSize = CGSize(width: 300, height: 180)
        segue.destination.popoverPresentationController?.sourceRect = CGRect(x: self.beerIcon.bounds.width/2, y: self.beerIcon.bounds.height/2, width: 300, height: 180)
        segue.destination.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
