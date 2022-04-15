//
//  TableCoinHeaderCell.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 2/4/2565 BE.
//

import UIKit

class TableCoinHeaderCell: UITableViewHeaderFooterView {
    static let reuseId = "TableCoinHeaderCell"
    static let cellHeight: CGFloat = 40
    
    @IBOutlet weak var lbTitle: UILabel!
    
    var title: NSMutableAttributedString! {
        didSet {
            lbTitle.attributedText = title
        }
    }
    
}
