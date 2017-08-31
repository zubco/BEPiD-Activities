//
//  CountrySelectionViewController.swift
//  AirMonitor
//
//  Created by Rafael Tomaz Prado on 28/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class CountrySelectionViewController: UIViewController, CountryCodeProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - API variables:
    // Object responsible for retrieving the country information from the API
    var countryServices: CountryServices = OpenAQCountryServices()
    // Array that holds
    var countries:[Country]? = [Country]()
    
    var countryCode: String?
    
//    let loadingCountriesQueue = OperationQueue()
    let mainQueue = OperationQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        self.countryServices.retrieveCoutries(completion: { [unowned self] (countries) in
                self.countries = countries
                
                self.mainQueue.addOperation {
                    self.tableView.reloadData()
                }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocations"{
            let vc = segue.destination as! CountryCodeProtocol
            vc.countryCode = self.countryCode
        }
    }
}

extension CountrySelectionViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryCell
        
        let country = self.countries?[indexPath.row]
        
        cell.countryName.text = country?.name
        cell.flagIcon.image = FlagMapper.flagIcon(code: country?.code)
        
        return cell
    }
}

extension CountrySelectionViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.countryCode = countries?[indexPath.row].code
        performSegue(withIdentifier: "showLocations", sender: self)
    }
}
