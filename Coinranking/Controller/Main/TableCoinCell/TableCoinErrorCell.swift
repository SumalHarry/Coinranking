//
//  TableCoinErrorCell.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 4/4/2565 BE.
//

import UIKit

class TableCoinErrorCell: UITableViewCell {
    static let reuseId = "TableCoinErrorCell"
    var viewModel: MainInterface!

    @IBAction func btnTryAgainAction(_ sender: Any) {
        viewModel.input.tryAgainAction()
    }
}
