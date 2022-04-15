//
//  UIColor.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 3/4/2565 BE.
//
import UIKit

extension UIColor {
    static var constColor: ConstColorStyle = ConstColorStyle()
}

class ConstColorStyle {
    func separatorColor() -> UIColor { return #colorLiteral(red: 0.9421718717, green: 0.9421719313, blue: 0.9421718717, alpha: 1) }
    func inviteLinkColor() -> UIColor { return #colorLiteral(red: 0.09647533866, green: 0.5777376635, blue: 0.9987046123, alpha: 1) }
    func changeIncreaseColor() -> UIColor { return #colorLiteral(red: 0.07301045209, green: 0.7368890047, blue: 0.1407504082, alpha: 1) }
    func changeDecreaseColor() -> UIColor { return #colorLiteral(red: 0.9722622037, green: 0.1778095365, blue: 0.1758657396, alpha: 1) }
    func progressViewColor() -> UIColor { return #colorLiteral(red: 0.2193158567, green: 0.6290507913, blue: 0.9987046123, alpha: 1) }
}

extension UIColor {
    func colorWithHexString(hexString: String, alpha:CGFloat = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        hexInt = UInt32(bitPattern: scanner.scanInt32(representation: .hexadecimal) ?? 0)
        return hexInt
    }
}
