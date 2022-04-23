//
//  GetCoinsViewModel.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 3/4/2565 BE.
//

import Foundation
import UIKit

struct CoinDisplayViewModel {
    let uuid: String?
    let symbol: String?
    let name: String?
    let iconUrl: String?
    let priceText: String?
    let changeText: String?
    let changeTextColor: UIColor
    let rank: Int?
  
    init?(model: GetCoinsCoin) {
        self.uuid = model.uuid
        self.iconUrl = model.iconUrl
        self.symbol = (model.symbol != nil) ? model.symbol: "No description"
        self.name = (model.name != nil) ? model.name: "No description"

        if let priceTxt = model.price, let price = Double(priceTxt) {
            self.priceText = "$\(price.withCommas(digits: 5))"
        } else {
            self.priceText = "No description"
        }
        
        if let changeTxt = model.change, var change = Double(changeTxt) {
            if change >= 0 {
                self.changeText = "\u{2191} \(change.withCommas(digits: 2))"
                self.changeTextColor = UIColor.constColor.changeIncreaseColor()
            } else if  change < 0 {
                change *= -1
                self.changeText = "\u{2193} \(change.withCommas(digits: 2))"
                self.changeTextColor = UIColor.constColor.changeDecreaseColor()
            } else {
                self.changeText = change.withCommas(digits: 2)
                self.changeTextColor = UIColor.black
            }
        } else {
            self.changeText = "No description"
            self.changeTextColor = UIColor.black
        }
        
        self.rank = model.rank
    }
}
