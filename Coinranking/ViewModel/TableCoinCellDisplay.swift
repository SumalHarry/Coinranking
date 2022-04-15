//
//  TableCoinCellDisplay.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 15/4/2565 BE.
//

import Foundation

struct TableCoinCellDisplay {
    let topRank: [CoinDisplayViewModel]
    let coins: [TableCoinCellDisplayViewModel]
   
    init(topRank: [CoinDisplayViewModel],coins: [TableCoinCellDisplayViewModel]) {
        self.topRank = topRank
        self.coins = coins
    }
}
