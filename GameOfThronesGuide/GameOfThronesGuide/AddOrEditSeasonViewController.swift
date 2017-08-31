//
//  AddOrEditSeasonViewController.swift
//  GameOfThronesGuide
//
//  Created by Fernando Celarino on 29/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation
import UIKit

class AddOrEditSeasonViewController : UITableViewController {
    /// season to be stored in case of updating operation
    var season:Season?
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var airedSwitch: UISwitch!
    @IBOutlet weak var resumeTextField: UITextField!
    
    
    override func viewDidLoad() {
        // call super
        super.viewDidLoad()
        
        // setup the ui with new data
        self.resumeTextField.text = season?.resume
        self.numberTextField.text = (season == nil ? "": String(describing:season!.number))
        self.airedSwitch.isOn = (season == nil ? false : season!.aired)
    }
    
    /// Function to validate input data, creating and saving notifications, and dismissing.
    @IBAction func saveSeason(_ sender: UIBarButtonItem) {
        // TODO: check if the form was correctly fullfilled
            // in according to the operation, grab information from ui and persist it
        if ( self.season != nil ) {
            // get information from UI
            self.season!.resume = self.resumeTextField.text!
            self.season!.number = Int16(self.numberTextField.text!)!
            self.season!.aired = self.airedSwitch.isOn
            
            // update the information
            SeasonServices.updateSeason(season: self.season!) { error in
                if (error != nil) {
                    // treat error if necessary
                }
            }
        }
        else {
            // initialize a new alarm get information from UI
            self.season = Season()
            self.season!.resume = self.resumeTextField.text!
            self.season!.number = Int16(self.numberTextField.text!)!
            self.season!.aired = self.airedSwitch.isOn
            
            // create new alarm
            SeasonServices.createSeason(season: self.season!) { error in
                if (error != nil) {
                    // treat error if necessary
                }
            }
        }
        
        // go back to the alarm list
        self.navigationController?.popViewController(animated: true)
    }
}
