//
//  Constants.swift
//  Coinranking
//
//  Created by Supawat Yongkasemkul on 3/4/2565 BE.
//

import Foundation

class Constants{
    static var BASE_URL : String {
        get{
            if let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String{
                return baseUrl
            }else{
                return ""
            }
        }
    }
  
    static var X_ACCESS_TOKEN : String {
        get{
            if let xAccessToken = Bundle.main.object(forInfoDictionaryKey: "X_ACCESS_TOKEN") as? String{
                return xAccessToken
            }else{
                return ""
            }
        }
    }
    
    static var INVITE_URL : String {
        get{
            if let inviteUrl = Bundle.main.object(forInfoDictionaryKey: "INVITE_URL") as? String{
                return inviteUrl
            }else{
                return ""
            }
        }
    }
}
