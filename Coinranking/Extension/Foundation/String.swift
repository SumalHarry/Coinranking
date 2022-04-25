//
//  String.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 3/4/2565 BE.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func convertToAttributedString(fontSize: Int = 17) -> NSAttributedString? {
            let modifiedFontString = "<span style=\"font-size: \(fontSize); color: rgb(85, 85, 85)\">" + self + "</span>"
            return modifiedFontString.htmlToAttributedString
        }
    
    var convertToDictionary: [String: Any]? {
        if let data = self.data(using: .utf8) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            }
            return nil
    }
}
