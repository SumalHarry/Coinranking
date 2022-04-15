//
//  Double.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 4/4/2565 BE.
//

import Foundation

extension Double {
    func withCommas(digits: Int = 2) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = digits
        return numberFormatter.string(from: NSNumber(value:self))!
    }
    
    var shortStringRepresentation: String {
        if self.isNaN {
            return "NaN"
        }
        if self.isInfinite {
            return "\(self < 0.0 ? "-" : "+")Infinity"
        }
        let units = ["", " k", " million", " billion", " trillion"]
        var interval = self
        var i = 0
        while i < units.count - 1 {
            if abs(interval) < 1000.0 {
                break
            }
            i += 1
            interval /= 1000.0
        }
        // + 2 to have one digit after the comma, + 1 to not have any.
        // Remove the * and the number of digits argument to display all the digits after the comma.
        return "\(String(format: "%0.*g", Int(log10(abs(interval))) + 3, interval))\(units[i])"
    }
}
