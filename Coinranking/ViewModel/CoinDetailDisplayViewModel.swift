//
//  CoinDetailViewModel.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 3/4/2565 BE.
//

import Foundation

// MARK: - Coin
struct CoinDetailDisplayViewModel {
    let uuid: String?
    let symbolText: String?
    let name: String?
    let iconUrl: String?
    let priceText: String?
    let description: String?
    let color: String?
    let marketCapText: String?
    let websiteUrl: String?
  
    init?(model: CoinDetailCoin) {
        self.uuid = model.uuid
        self.iconUrl = model.iconUrl

        if let symbol = model.symbol {
            self.symbolText = "(" + symbol + ")"
        }
        else {
            self.symbolText = "No description"
        }
        
        self.name = model.name ?? "No description"
        self.description = model.description ?? "No description"
        self.color = model.color
        self.websiteUrl = model.websiteUrl
        
        if let priceTxt = model.price, let price = Double(priceTxt) {
            self.priceText = "$ \(price.withCommas(digits: 5))"
        } else {
            self.priceText = "No description"
        }
        
        if let marketCapTxt = model.marketCap, let marketCap = Double(marketCapTxt) {
            self.marketCapText = "$ \(marketCap.shortStringRepresentation)"
        } else {
            self.marketCapText = "No description"
        }
    }
}
