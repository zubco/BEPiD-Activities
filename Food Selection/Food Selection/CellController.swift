//
//  CellController.swift
//  Food Selection
//
//  Created by Rafael Tomaz Prado on 23/03/17.
//  Copyright © 2017 Rafael Tomaz Prado. All rights reserved.
//

import UIKit

class CellController: UITableViewCell {

    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
