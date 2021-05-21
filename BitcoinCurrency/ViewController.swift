//
//  ViewController.swift
//  BitcoinCurrency
//
//  Created by user188302 on 5/18/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {



    @IBOutlet weak var valorLabel: UILabel!
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    

    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
    let curruncies = ["AUD", "BRL", "CAD", "CNY", "EUR", "OBP", "HKD", "IDR", "ILS", "INR", "JPY","MXN","NOK","PLN","RON","RUB","SEK","SOD","USD","ZAR"]



    let publicKey = "MWExMDk2MTNhM2JmNDE3MGE4MzMwYTIwY2E3MDhlNjA"
    
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            pickerView.delegate = self
            pickerView.dataSource = self
            fetchData(url: baseUrl)
    
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return curruncies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return curruncies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
                fetchData(url: url)
        
    }

    func fetchData(url: String) {
        
        let url = URL(string: url)!
        
        var request = URLRequest (url: url)
        request.httpMethod = "GET"
        request.addValue(publicKey,forHTTPHeaderField: "x-ba-key")

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data {
                self.parseJSON(json: data)
            } else {
                print("Erro")
            }
        }
        task.resume()
    }

    func parseJSON(json: Data){
           
            do {
                if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                           print(json)
                if let askValue = json["ask"] as? NSNumber {
                    print(askValue)
                     //.currency
                    
                let numberFormatter = NumberFormatter()
                    numberFormatter.locale = Locale(identifier: "pt_BR")
                    numberFormatter.minimumFractionDigits = 2
                    //numberFormatter.positiveFormat = "#0.000,00"
                    numberFormatter.numberStyle = .decimal
                
                //let askvalueString = "\(askValue)"
                    DispatchQueue.main.async {
                        
                        let valor = numberFormatter.string(from: askValue as NSNumber)
                        self.valorLabel.text = valor               }
                    print("sucess")
                } else {
                    print("error")
                }
            }
        } catch {
            
            print("error parsing json: \(error)")
        }
    }

    }
