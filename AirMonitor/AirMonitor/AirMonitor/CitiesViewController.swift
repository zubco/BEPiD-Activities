//
//  LocationsViewController.swift
//  AirMonitor
//
//  Created by Rafael Tomaz Prado on 28/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class CitiesViewController: UIViewController, CountryCodeProtocol, CityCodeProtocol{
    
    @IBOutlet weak var locationsTable: UITableView!
    
    var cities: [City]? = [City]()
    
    var countryCode: String?
    var cityCode: String?
    
    var citiesServices: CitiesServices = OpenAQCitiesServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsTable.dataSource = self
        locationsTable.delegate = self
        
        citiesServices.retrieveCities(for: countryCode!, completion: { [unowned self] (cities) in
            
            self.cities = cities
            OperationQueue.main.addOperation {
                self.locationsTable.reloadData()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cityDetail"){
            let dest = segue.destination as! LocationsViewController
            
            dest.navItem.title = self.cityCode
            dest.cityCode = self.cityCode
        }
    }
}

extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationsTable.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationCell
        
        let city = cities?[indexPath.row]
        
        cell.cityName.text = city?.name
        
        return cell
    }
}

extension CitiesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cityCode = cities?[indexPath.row].name
        performSegue(withIdentifier: "cityDetail", sender: self)
    }
}
