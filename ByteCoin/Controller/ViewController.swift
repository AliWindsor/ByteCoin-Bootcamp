//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var coinManager = CoinManager()
    var selectedCurrency : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coinManager.delegate = self
        
        coinPrice.text = "0.00"
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
}

extension ViewController: CoinManagerDelegate {
    func didGetRate(_ coinManager: CoinManager, coin: Float) {
        DispatchQueue.main.async {
            self.coinPrice.text = String(format: "%.2f" , coin)
        }
    }
    
    func didSendError(_ error: Error) {
        print(error)
    }
    
    
}

//MARK: - Picker Delegate / Data Source
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
  
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let rate = currencyLabel.text  {
            coinManager.getPrice(currency: rate)
        }
        currencyLabel.text = coinManager.currencyArray[row]
    }
}

