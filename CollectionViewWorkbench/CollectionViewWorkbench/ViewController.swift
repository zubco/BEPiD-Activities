//
//  ViewController.swift
//  CollectionViewWorkbench
//
//  Created by Rafael Tomaz Prado on 06/04/17.
//  Copyright © 2017 Rafael Tomaz Prado. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate let reuseId = "Cell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var result: UILabel!
    private let images = ["archer.png", "mage.png", "knight.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collection.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ cellForItemAtcollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collection.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CollectionCell
        
        cell.imageView.frame = CGRect(x: 0, y: 0, width: cell.imageView.frame.width, height: cell.imageView.frame.height)
        cell.imageView.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionCell
        
        cell.imageView.layer.borderColor = UIColor.red.cgColor
        cell.imageView.layer.borderWidth = 2.0
        cell.imageView.layer.cornerRadius = 10.0
        
        result.text = images[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionCell
        
        cell.imageView.layer.borderColor = UIColor.white.cgColor
        cell.imageView.layer.borderWidth = 0
        cell.imageView.layer.cornerRadius = 10
    }
    
    
}

