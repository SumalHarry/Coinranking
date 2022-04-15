//
//  UIImage.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 4/4/2565 BE.
//

import UIKit

extension UIImageView {
    func setRoundImageView() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}
