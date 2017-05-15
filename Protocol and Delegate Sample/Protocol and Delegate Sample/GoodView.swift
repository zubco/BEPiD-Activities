//
//  GoodView.swift
//  Protocol and Delegate Sample
//
//  Created by Gustavo Lima on 15/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

protocol GoodViewDelegate : NSObjectProtocol {

    func information() -> String

}

class GoodView: UIView {

    var delegate: GoodViewDelegate?


    func showInformation(){
        
        if let delegate = self.delegate
        {
            let message = delegate.information()
            
            let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 30)))
            
            label.text = message
            
            self.addSubview(label)
            
        }
    }
    
}
