//
//  TableCoinSearchCell.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 2/4/2565 BE.
//

import UIKit
import Kingfisher
import SVGKit

class TableCoinSearchCell: UITableViewCell {
    static let reuseId = "TableCoinSearchCell"
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbSymbol: UILabel!
    @IBOutlet weak var lbPriceText: UILabel!
    @IBOutlet weak var lbChangeText: UILabel!
    
    private let svgRatio = 0.8
    
    var coinViewModel: CoinDisplayViewModel! {
        didSet {
            if let iconUrl = coinViewModel.iconUrl {
                for view in viewImage.subviews {
                    view.removeFromSuperview()
                }
                
                for view in viewImage.subviews {
                    view.removeFromSuperview()
                }
                
                if(iconUrl.uppercased().range(of: "SVG") != nil) {
                    let url = URL(string: iconUrl)
                    let data = try? Data(contentsOf: url!)
                    let receivedimage: SVGKImage = SVGKImage(data: data)
                    
                    let viewBox = receivedimage.domTree.viewBox
                    let size = receivedimage.size
                    

                    if abs(Double(viewBox.width / viewBox.height)) < svgRatio {
                        receivedimage.scaleToFit(inside: CGSize(width: receivedimage.size.width, height: imageViewIcon.frame.height))
                    } else {
                        receivedimage.scaleToFit(inside: CGSize(width: imageViewIcon.frame.width, height: imageViewIcon.frame.height))
                    }
                    
                    imageViewIcon.image = receivedimage.uiImage
                    imageViewIcon.contentMode = .scaleAspectFit
                } else {
                    let url = URL(string: iconUrl)
                    imageViewIcon.kf.setImage(with: url)
                }
            }
            
            lbName.text = coinViewModel.name
            lbSymbol.text = coinViewModel.symbol
            lbPriceText.text = coinViewModel.priceText
            lbChangeText.text = coinViewModel.changeText
            lbChangeText.textColor = coinViewModel.changeTextColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        // corner radius
        viewCell.setCornerRadius(radius: 8)
        viewCell.setShadow(radius: 8)
    }
}
