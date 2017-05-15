//
//  StartGameProtocol.swift
//  WhereIsWallien
//
//  Created by Rafael Tomaz Prado on 12/05/17.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import Foundation

//Protocol used to guarantee the view controller will have a parameter to control exhibition of the skip button
protocol SkipButtonProtocol {
    var shouldDisplaySkipButton:Bool?{ get set}
}
