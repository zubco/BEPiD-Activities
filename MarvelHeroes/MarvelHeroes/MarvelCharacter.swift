//
//  MarvelCharacter.swift
//  MarvelHeroes
//
//  Created by Gustavo Lima on 09/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit


/// Representa um Character de um herói retornado pela API da Marvel
public class MarvelCharacter: MarvelObject {


    // Foram implementados apenas os atributos necessários para 
    // este exemplo, a API tem muita informação que não está mapeada neste objeto
    
    public var name:String?
    public var bioDescription:String?
    public var thumbnailUrl: URL?

}
