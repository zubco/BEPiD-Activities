//
//  ViewController.swift
//  CustomViewSample
//
//  Created by Gustavo Lima on 4/29/15.
//  Copyright (c) 2015 bepid. All rights reserved.
//

import UIKit

class GraphicViewController: UIViewController, GraphicViewDataSource {

    @IBOutlet weak var graphicViewAMZN: GraphicView!
    
    @IBOutlet weak var graphicViewAAPL: GraphicView!

    func numberOfDataPoints(in graphicView: GraphicView) -> Int
    {
        let points = StockData.stockDataPoints[graphicView.title]!
        
        return points.count
    }
    
    func graphicView(_ graphicView: GraphicView, dataPointForIndex index: Int) -> Float
    {
        let points = StockData.stockDataPoints[graphicView.title]!
        
        return points[index]
    }

    @IBAction func refresh(_ sender: Any) {
        
        StockData.downloadData(stock:graphicViewAAPL.title)

        graphicViewAAPL.reloadData()
    }
}

