//
//  CoinManager.swift
//  Dollar $
//
//  Created by Mohamed Aboullezz on 05/01/2023.
//

import Foundation
import UIKit
protocol CoinManagerDelegate {
    func didFailWithErro(error: Error)
    func didUpdateCoin(price: String, currency: String)
}
struct CoinManager {
//    https://api.fastforex.io/fetch-one?from=USD&to=EUR&api_key=6d6ad184c7-b4bc7e6e2a-ro0lf2
    var delegate:CoinManagerDelegate?
//    /fetch-one?from=USD&to=EUR
    let baseURL = "https://api.fastforex.io"
    let apiKey = "6d6ad184c7-b4bc7e6e2a-ro0lf2"
    let currencyArray = ["EGP", "IQD", "SYP" ,"LBP", "JOD" , "SAR" ,"YER","LYD","SDG","MAD","TND","KWD","DZD","BHD","QAR","AED","OMR","USD","EUR","AUD","CAD","TRY","CNH","JPY","HKD","HRK","PLN","RUB","CHF"
    ]
    func getCoinPrice (for currency: String) {
//        let urlString = "\(baseURL)/fetch-one?from=USD&to=\(currency)&api_key=\(apiKey)"
//        let urlString = "\(baseURL)/fetch-all?api_key=\(apiKey)"
        let urlString = "\(baseURL)/fetch-one?from=USD&to=\(currency)&api_key=\(apiKey)"

        print(urlString)
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, responce, error) in
                if error != nil {
                    delegate?.didFailWithErro(error: error!)
                    return
                }
                if let response = data {
                    if let dollarPrice = self.parseJSON(response, currency: currency) {
                        let priceString = String(format: "%.3f", dollarPrice)
                        self.delegate?.didUpdateCoin(price: priceString, currency: currency)
                    }
                }
                //print(dataAsString!)
            }
            task.resume()
        }
        
    }
    
    func parseJSON (_ coinData: Data, currency: String) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodeData.result
            //return lastPrice[lastPrice.first?.key ?? ""]
            return lastPrice[currency]
            
        }catch {
            delegate?.didFailWithErro(error: error)
            return nil
        }
    }
}


