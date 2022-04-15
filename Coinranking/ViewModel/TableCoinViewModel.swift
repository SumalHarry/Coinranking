//
//  TableCoinViewModel.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 4/4/2565 BE.
//

import Foundation

enum TableCoinCellType: Int, CaseIterable {
    case normal
    case invite
    case loading
    case error
}

struct TableCoinCellDisplayViewModel {
    var cellType: TableCoinCellType
    let coinViewModel: CoinDisplayViewModel?
   
  
    init(cellType: TableCoinCellType,coinViewModel: CoinDisplayViewModel? = nil) {
        self.cellType = cellType
        self.coinViewModel = coinViewModel
    }
}
