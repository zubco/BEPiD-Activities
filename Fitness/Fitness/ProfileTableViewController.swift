//
//  ProfileTableViewController.swift
//  Fitness
//
//  Created by Marcelo Reina on 14/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var ageText: UILabel!
    @IBOutlet weak var weightText: UILabel!
    @IBOutlet weak var heightText: UILabel!
    @IBOutlet weak var sexText: UILabel!
    
    let unavailableText = "indisponível"
    let loadingText = "carregando"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)

        HealthKitManager.shared.requestUserPermission { (hasPermission) in
            print("Request permission operation succeeded: \(hasPermission)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData() {
        
        if let age = ProfileService.getProfileAge() {
            ageText.text = "\(age)"
        } else {
            ageText.text = unavailableText
        }
        
        if let biologicalSex = ProfileService.getProfileBiologicaSex() {
            sexText.text = biologicalSex
        } else {
            sexText.text = unavailableText
        }
        
        heightText.text = loadingText
        ProfileService.getProfileHeight { (value, unit) in
            if let heightValue = value , let unitString = unit {
                self.heightText.text = "\(heightValue) \(unitString)"
            } else {
                self.heightText.text = self.unavailableText
            }
            
            if self.refreshControl!.isRefreshing {
                self.refreshControl!.endRefreshing()
            }
        }
        
        weightText.text = loadingText
        ProfileService.getProfileWeight { (value, unit) in
            if let weightValue = value , let unitString = unit {
                self.weightText.text = "\(weightValue) \(unitString)"
            } else {
                self.weightText.text = self.unavailableText
            }

            
            if self.refreshControl!.isRefreshing {
                self.refreshControl!.endRefreshing()
            }
        }
    }
    
}
