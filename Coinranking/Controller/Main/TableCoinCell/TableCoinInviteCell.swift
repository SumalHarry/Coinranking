//
//  TableCoinInviteCell.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 2/4/2565 BE.
//

import UIKit

class TableCoinInviteCell: UITableViewCell {
    static let reuseId = "TableCoinInviteCell"

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lbInviteFriend: UILabel!
    @IBOutlet weak var imgGift: UIImageView!
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup(){
        viewCell.setCornerRadius(radius: 8)
        viewCell.setShadow(radius: 8)
        
        imgGift.setRoundImageView()
        
        let stringOne = "You can earn $10 when you invite a friend to buy crypto. Invite your friend"
        let stringTwo = "Invite your friend"

        let range = (stringOne as NSString).range(of: stringTwo)

        let attributedText = NSMutableAttributedString.init(string: stringOne)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.constColor.inviteLinkColor() , range: range)
        lbInviteFriend.attributedText = attributedText
    }
}
