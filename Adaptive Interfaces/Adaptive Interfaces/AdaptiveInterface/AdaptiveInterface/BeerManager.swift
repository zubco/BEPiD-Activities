//
//  BeerManager.swift
//  AdaptiveInterface
//
//  Created by SERGIO J RAFAEL ORDINE on 15/05/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class BeerManager {
    
    static let beerList:[Beer] = [
        Beer(name: "Skol", imageName: "Skol", description: "Currently, Skol is the most popular beer in Brazil. It was originally produced by Caracu, which was bought by Brahma in 1980. In 1999, Brahma merged with Antarctica and became AmBev, then InBev and later AB InBev. AB Inbev is the biggest beverage company in the world, larger than Coca-Cola in revenue. Skol beer became internationally recognized as a Brazilian beer, though not initially conceived in Brazil.", type: .pilsner),
        Beer(name: "Heineken", imageName: "Heineken", description: "Heineken Lager Beer (Dutch: Heineken Pilsener), or simply Heineken (Dutch pronunciation: [ˈɦɛinəkən]), is a pale lager beer with 5% alcohol by volume produced by the Dutch brewing company Heineken International. Heineken is well known for its signature green bottle and red star.", type: .pilsner),
        Beer(name: "Erdinger", imageName: "Erdinger", description: "Erdinger is the world's largest wheat beer brewery. It is widely available and popular across Germany and the European Union. Erdinger was founded in 1886 by Johann Kienle. Erdinger beer is the best-known culinary product of the city; however, the brewery did not receive its current name until 1949 from its owner Franz Brombach, who had acquired the brewery 14 years earlier. The current owner is Franz Brombach's son, Werner Brombach (from 1975).", type: .weissbier),
        Beer(name: "Paulaner", imageName: "Paulaner", description: "Paulaner is a German brewery, established in 1634 in Munich by the Minim friars of the Neudeck ob der Au cloister. The mendicant order and the brewery are named after Francis of Paola, the founder of the order. Paulaner is one of the six breweries who provide beer for Oktoberfest, the German beer festival dating from 1810.", type: .weissbier),
        Beer(name: "Guinness", imageName: "Guinness", description: "Guinness(known as 'The best import from Ireland' in America), is an Irish dry stout that originated in the brewery of Arthur Guinness (1725–1803) at St. James's Gate, Dublin. Guinness is one of the most successful beer brands worldwide. It is brewed in almost 60 countries and is available in over 120. Annual sales total 850 million litres (1.5 billion Imperial or 1.8 billion US pints)", type: .stout)
    ]
    
    
    static func beers()->[Beer] {
        return beerList;
    }

    static var defaultBeer: Beer {
        get {
            return beerList[0]
        }
    }
    

}
