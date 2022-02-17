//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didGetRate(_ coinManager : CoinManager, coin : Float)
    func didSendError(_ error : Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate : CoinManagerDelegate?
    
    func getPrice(currency : String) {
        let url = "\(baseURL)/\(currency)/?APIKey=\(apiKey)"
        
        performRequest(with: url)
    }
    
    func performRequest(with urlString : String) {
        
        if let url = URL(string: urlString){

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request ) { (data, response, error) in
               print("task triggered")
                if error != nil {
                    self.delegate?.didSendError(error!)
                    return
                }
                
                if let safeData = data {
                    if let rate = self.parseJSON(coinPriceData : safeData){
                        self.delegate?.didGetRate(self, coin: rate)

                    }
                }
     
            }
            
            task.resume()
            
        }else{
            print("haha no")
        }
        
    }
    
    func parseJSON (coinPriceData: Data) -> Float? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinModel.self, from: coinPriceData)
            let rate = decodedData.rate
            
            return(rate)
        }catch{
            self.delegate?.didSendError(error)
            return nil
        }
        
    }
    
}
