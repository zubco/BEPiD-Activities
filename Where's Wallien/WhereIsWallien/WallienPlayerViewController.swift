//
//  ViewController.swift
//  WhereIsWallien
//
//  Created by Gustavo Lima on 26/04/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class WallienPlayerViewController: UIViewController, UITextFieldDelegate, SkipButtonProtocol {
   
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    //Used to persist local options between execution
    fileprivate let defaults:UserDefaults = UserDefaults()
    
    //Checks if tutorial should show skip button (form StartGameProtocol)
    var shouldDisplaySkipButton: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets the text view delegate
        textField.delegate = self
        //Initializes our protocol variable
        self.shouldDisplaySkipButton = Bool(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Resets the text field conditions when opening the screen
        textField.text = String()
        textField.resignFirstResponder() 
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "helpSegue"{
            //Always show the tutorial if touched on info button
            return true
        }
        
        if identifier == "goToTutorial"{
            // checks if user has entered a name, if not shakes the textfield
            if (self.textField.text?.isEmpty == true){
                self.textField.shake()
                return false
            }
            else{
                //checks if it is the first playthrough and displays (or not) tutorial accordingly
                if !defaults.bool(forKey: "first"){
                    defaults.set(true, forKey: "first")
                    return true
                }
                else{
                    //if it is not the first time, bypasses the tutorial view
                    performSegue(withIdentifier: "bypass", sender: self)
                    return false
                }
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if tutorial is accessed from info button, sets the parameter to hide Skip button
        if segue.identifier == "helpSegue"{
            var nextViewController = segue.destination as! SkipButtonProtocol
            nextViewController.shouldDisplaySkipButton = self.shouldDisplaySkipButton!
        }
        //Sets parameter to show skip button
        if segue.identifier == "goToTutorial"{
            self.shouldDisplaySkipButton = true
            var nextViewController = segue.destination as! SkipButtonProtocol
            nextViewController.shouldDisplaySkipButton = self.shouldDisplaySkipButton!
        }
    }
    
    //Hides keyboard upon hitting the return key.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Raises the content inside the scroll view, so it's no hidden by the keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let point = CGPoint(x: 0, y: 130)
        scrollView.setContentOffset(point, animated: true)
    }
    //Puts it back in place after using it.
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: -40), animated: true)
    }
    
}

