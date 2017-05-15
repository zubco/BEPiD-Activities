//
//  ViewController.swift
//  TextFieldsWorkbench
//
//  Created by Rafael Tomaz Prado on 04/04/17.
//  Copyright © 2017 Rafael Tomaz Prado. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Protocol, UITextFieldDelegate {
    
    var textFromField:String?
    var textFromView:String?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        self.textField.placeholder = "Insert String here."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.textFromField = self.textField.text
        self.textFromView = self.textView.text
        var nextViewController = segue.destination as! Protocol
        nextViewController.textFromField = self.textFromField!
        nextViewController.textFromView = self.textFromView!
    }
    
    @IBAction func nextPressed(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "first", sender: nextButton)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

