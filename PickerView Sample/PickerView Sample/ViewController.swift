//
//  ViewController.swift
//  PickerView Sample
//
//  Created by Gustavo Lima on 14/05/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate{

    
    // 1 - Exemplo de picker view
    
    @IBOutlet weak var label: UILabel!
    
    var pickerData = [
        ["1", "2", "3", "4","5","6"],// primeira coluna
        ["a", "b", "c", "d"],        // segunda coluna
        ["!", "#", "$", "%"],        // terceira coluna
        ["x", "y", "z"]              // quarta coluna
    ]
   
    // MARK: UIPickerViewDataSource
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        // retorna o numero de colunas
        return self.pickerData.count
    }
    

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        // recupera os valores da coluna "component"
        let componentData = self.pickerData[component]
        
        // returna o numero de valores dentro dessa coluna
        return componentData.count
    }


    // MARK: UIPickerViewDelegate
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        // string com o titulo que deve ser exibido
        return self.pickerData[component][row]
    }
    
    
    // 2 - Exemplo de pegar valor selecionado
    
     var selectedData = ["1","a","!","x"] // Primeiro valor de cada coluna
    
    /// Atualiza o label com os valores do pickerview
    func updateLabel()
    {
        self.label.text = self.selectedData.joined(separator: ", ")
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.selectedData[component] = self.pickerData[component][row]
        
        updateLabel()
    }
    
    // 3 - Exemplo date picker
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        
        self.label.text = String(describing: datePicker.date)
    }
    
}









