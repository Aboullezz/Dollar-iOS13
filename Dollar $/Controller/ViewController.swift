//
//  ViewController.swift
//  Dollar $
//
//  Created by Mohamed Aboullezz on 05/01/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}
//MARK:- CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    
    func didUpdateCoin(price: String, currency: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = price
            
            self.dollarLabel.text = currency
        }
    }
    
    func didFailWithErro(error: Error) {
        print(error)
    }
}
//MARK:- UIPickerViewDataSource, UIPickerViewDelegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
//        print(selectedCurrency)
    }
    
}
