//
//  LocationsViewController.swift
//  AirMonitor
//
//  Created by Rafael Tomaz Prado on 30/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class LocationsViewController: UIViewController, CityCodeProtocol{

    @IBOutlet weak var locationsTable: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var sections:[Location]? = [Location]()
    
    var cityCode: String?
    
    var locationServices:LocationServices = OpenAQLocationServices()
    var measurementServices = OpenAQMeasureServices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsTable.dataSource = self
        locationsTable.delegate = self
        
        locationServices.retrieveLocations(for: cityCode!, completion: { [unowned self]
            (locations) in
            self.sections = locations
            
//            for location in self.sections!{
//                measurementServices.retrieveMeasures(location: location.name, completion: {_ in })
//            }
            
            OperationQueue.main.addOperation {
                self.locationsTable.reloadData()
                print("terminei o request")
            }
        })
    }
}

extension LocationsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsableSectionView
        
        header?.titleLabel.text = sections?[section].name
        header?.arrowLabel.text = ">"
        header?.setCollapsed((sections?[section].collapsed)!)
        
        header?.section = section
        header?.delegate = self
        
        return header
    }
}

extension LocationsViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections![section].collapsed ? 0:(sections![section].measures?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell? ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
//        cell.textLabel?.text = sections?[indexPath.section].name
        cell.textLabel?.text = "teste da massa"
        return cell
    }
    
}

extension LocationsViewController:CollapsableSectionDelegate{
    func toggleSection(_ header: CollapsableSectionView, section: Int) {
        
        sections?[section].collapsed = !(sections?[section].collapsed)!
        
        header.setCollapsed((sections?[section].collapsed)!)
        
        locationsTable.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        
    }
}
