//
//  CollapsableSectionView.swift
//  AirMonitor
//
//  Created by Rafael Tomaz Prado on 31/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

protocol CollapsableSectionDelegate {
    func toggleSection(_ header: CollapsableSectionView, section: Int)
}

class CollapsableSectionView: UITableViewHeaderFooterView {

    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    
    var delegate:CollapsableSectionDelegate?
    var section:Int = 0
    
    override init(reuseIdentifier:String?){
        super.init(reuseIdentifier: reuseIdentifier)
        
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsableSectionView.headerTap(_:))))
        
        
        //View Auto Layout
        
        contentView.backgroundColor = UIColor.clear
        
        let marginGuide = contentView.layoutMarginsGuide
        
        //Arrow View
        contentView.addSubview(arrowLabel)
        arrowLabel.textColor = UIColor.white
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func headerTap(_ gestureRecognizer: UITapGestureRecognizer){
        guard let cell = gestureRecognizer.view as? CollapsableSectionView else{
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool){
        arrowLabel.isHidden = !collapsed
    }
}
