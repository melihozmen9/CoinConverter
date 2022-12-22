//
//  CoinManager.swift
//  CoinConverter
//
//  Created by Kullanici on 22.12.2022.
//

import Foundation
protocol CoinManagerDelegate {
    func getCoin(coin:CoinData)
}
struct CoinManager {
    var delegate : CoinManagerDelegate
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "12F3451D-1748-4F66-912F-320A3D152C5E"
    func getCoinPrice(For currency:String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
   
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            if let safeData = data {
                let coin = parseJSON(coin: safeData)
                self.delegate.getCoin(coin: coin)
            }
        }
        task.resume()
    }
    func parseJSON(coin:Data){
    let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(CoinData.self, from: coin)
            let rate = decodedData.rate
            let coin = CoinData(rate:rate)
            print(rate)
        } catch  {
            print(error)
        }
    }
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
}

