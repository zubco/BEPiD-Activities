//
//  BadView.swift
//  Protocol and Delegate Sample
//
//  Created by Gustavo Lima on 15/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class BadView: UIView {

    var badViewController: BadViewController?
    
    func showInformation(){
        
        if let vc = self.badViewController
        {
            let message = vc.information()
            
            let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 30)))
            
            label.text = message
        
            self.addSubview(label)
        }
    }
}
